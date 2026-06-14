#import "TerminalSession.h"
#import <sys/ioctl.h>
#import <sys/types.h>
#import <sys/wait.h>
#import <unistd.h>
#import <fcntl.h>
#import <util.h>

@interface TerminalSession () {
    int _ptyFD;
    pid_t _childPid;
    BOOL _isConnected;
    NSThread *_readThread;
}

@end

@implementation TerminalSession

@synthesize delegate = _delegate, isConnected = _isConnected, ptyFD = _ptyFD, processID = _childPid;

- (void)connectToLocalShell {
    struct winsize win = {
        .ws_row = 24,
        .ws_col = 80,
        .ws_xpixel = 0,
        .ws_ypixel = 0
    };
    
    _childPid = forkpty(&_ptyFD, NULL, NULL, &win);
    
    if (_childPid < 0) {
        NSLog(@"Failed to create PTY: %d", errno);
        if ([_delegate respondsToSelector:@selector(session:didFailWithError:)]) {
            NSError *error = [NSError errorWithDomain:@"TerminalSession" code:errno userInfo:nil];
            [_delegate session:self didFailWithError:error];
        }
        return;
    }
    
    if (_childPid == 0) {
        setenv("TERM", "xterm-256color", 1);
        setenv("HOME", "/var/mobile", 1);
        execl("/bin/sh", "sh", NULL);
        exit(127);
    }
    
    fcntl(_ptyFD, F_SETFL, fcntl(_ptyFD, F_GETFL, 0) | O_NONBLOCK);
    _isConnected = YES;
    
    [self startReadingPTY];
    
    if ([_delegate respondsToSelector:@selector(sessionDidConnect:)]) {
        [_delegate sessionDidConnect:self];
    }
}

- (void)startReadingPTY {
    _readThread = [[NSThread alloc] initWithTarget:self selector:@selector(readPTYLoop) object:nil];
    [_readThread start];
}

- (void)readPTYLoop {
    @autoreleasepool {
        while (_isConnected && _ptyFD > 0) {
            fd_set readfds;
            FD_ZERO(&readfds);
            FD_SET(_ptyFD, &readfds);
            
            struct timeval tv = {0, 10000}; // 10ms timeout
            
            int result = select(_ptyFD + 1, &readfds, NULL, NULL, &tv);
            
            if (result > 0 && FD_ISSET(_ptyFD, &readfds)) {
                char buffer[4096];
                ssize_t bytesRead = read(_ptyFD, buffer, sizeof(buffer));
                
                if (bytesRead > 0) {
                    NSData *data = [NSData dataWithBytes:buffer length:bytesRead];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self->_delegate respondsToSelector:@selector(session:didReceiveData:)]) {
                            [self->_delegate session:self didReceiveData:data];
                        }
                    });
                } else if (bytesRead < 0 && errno != EAGAIN && errno != EWOULDBLOCK) {
                    break;
                }
            }
            
            usleep(1000);
        }
    }
}

- (void)sendString:(NSString *)string {
    if (_isConnected && _ptyFD > 0) {
        const char *str = [string UTF8String];
        write(_ptyFD, str, strlen(str));
    }
}

- (void)sendByte:(unsigned char)byte {
    if (_isConnected && _ptyFD > 0) {
        write(_ptyFD, &byte, 1);
    }
}

- (void)sendKeyBackspace {
    [self sendByte:0x08];
}

- (void)sendKeyDelete {
    [self sendByte:0x7F];
}

- (void)sendKeyEnter {
    [self sendByte:'\r'];
}

- (void)sendKeyArrowUp {
    [self sendString:@"\x1B[A"];
}

- (void)sendKeyArrowDown {
    [self sendString:@"\x1B[B"];
}

- (void)sendKeyArrowLeft {
    [self sendString:@"\x1B[D"];
}

- (void)sendKeyArrowRight {
    [self sendString:@"\x1B[C"];
}

- (void)disconnect {
    if (_isConnected) {
        _isConnected = NO;
        
        if (_childPid > 0) {
            kill(_childPid, SIGTERM);
            waitpid(_childPid, NULL, 0);
        }
        
        if (_ptyFD > 0) {
            close(_ptyFD);
        }
        
        if ([_delegate respondsToSelector:@selector(sessionDidDisconnect:)]) {
            [_delegate sessionDidDisconnect:self];
        }
    }
}

- (void)dealloc {
    [self disconnect];
}

@end
