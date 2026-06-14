#import <UIKit/UIKit.h>

@class TermView;
@class TerminalSession;

@interface TermViewController : UIViewController {
    TermView *_termView;
    TerminalSession *_session;
    UIToolbar *_toolbar;
    UIBarButtonItem *_newTabButton;
    UIBarButtonItem *_settingsButton;
    UIBarButtonItem *_copyButton;
    BOOL _isConnected;
}

@property (nonatomic, retain) TermView *termView;
@property (nonatomic, retain) TerminalSession *session;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, assign) BOOL isConnected;

- (void)newTerminalSession;
- (void)showSettings;
- (void)copyTerminalText;

@end
