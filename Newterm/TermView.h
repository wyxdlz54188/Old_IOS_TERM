#import <UIKit/UIKit.h>
#import "TerminalSession.h"

@interface TermView : UIScrollView <UIScrollViewDelegate, UITextFieldDelegate, TerminalSessionDelegate> {
    TerminalSession *_session;
    UITextField *_hiddenInput;
    NSMutableArray *_displayLines;
    UIFont *_terminalFont;
    CGFloat _lineHeight;
    CGFloat _charWidth;
    NSInteger _columns;
    NSInteger _rows;
    BOOL _cursorVisible;
    NSTimer *_cursorBlinkTimer;
    CGFloat _kbHeight;
}

@property (nonatomic, retain) TerminalSession *session;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL cursorVisible;

- (void)appendText:(NSString *)text;
- (void)clearScreen;
- (void)scrollToBottom;

@end
