#import <Foundation/Foundation.h>

@class TerminalSession;

@protocol TerminalSessionDelegate <NSObject>
@optional
- (void)sessionDidConnect:(TerminalSession *)session;
- (void)sessionDidDisconnect:(TerminalSession *)session;
- (void)session:(TerminalSession *)session didReceiveData:(NSData *)data;
- (void)session:(TerminalSession *)session didFailWithError:(NSError *)error;
@end

@interface TerminalSession : NSObject

@property (nonatomic, weak) id<TerminalSessionDelegate> delegate;
@property (nonatomic, readonly) BOOL isConnected;
@property (nonatomic, readonly) int ptyFD;
@property (nonatomic, readonly) pid_t processID;

- (void)connectToLocalShell;
- (void)sendString:(NSString *)string;
- (void)sendByte:(unsigned char)byte;
- (void)sendKeyBackspace;
- (void)sendKeyDelete;
- (void)sendKeyEnter;
- (void)sendKeyArrowUp;
- (void)sendKeyArrowDown;
- (void)sendKeyArrowLeft;
- (void)sendKeyArrowRight;
- (void)disconnect;

@end
