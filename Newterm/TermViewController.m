#import "TermViewController.h"
#import "TermView.h"
#import "TerminalSession.h"
#import "SettingsViewController.h"

@implementation TermViewController

@synthesize termView = _termView, session = _session;
@synthesize toolbar = _toolbar, isConnected = _isConnected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _isConnected = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NewTerm";
    
    self.session = [[TerminalSession alloc] init];
    
    CGFloat toolbarHeight = 44.0;
    CGRect terminalFrame = CGRectMake(0, 0, self.view.frame.size.width,
                                       self.view.frame.size.height - toolbarHeight);
    
    self.termView = [[TermView alloc] initWithFrame:terminalFrame];
    self.termView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.termView.session = self.session;
    self.session.delegate = self.termView;
    [self.view addSubview:self.termView];
    
    [self setupToolbar];
    
    [self.termView appendText:@"NewTerm for iOS 6\n"];
    [self.termView appendText:@"wyxdlz54188.newterm\n\n"];
    
    [self newTerminalSession];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.termView = nil;
    self.session = nil;
}

- (void)setupToolbar {
    CGFloat toolbarHeight = 44.0;
    CGRect toolbarFrame = CGRectMake(0, self.view.frame.size.height - toolbarHeight,
                                       self.view.frame.size.width, toolbarHeight);
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.newTabButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                        target:self
                                                                        action:@selector(newTerminalSession)];
    
    self.settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"设置"
                                                            style:UIBarButtonItemStyleBordered
                                                           target:self
                                                           action:@selector(showSettings)];
    
    self.copyButton = [[UIBarButtonItem alloc] initWithTitle:@"复制"
                                                        style:UIBarButtonItemStyleBordered
                                                       target:self
                                                       action:@selector(copyTerminalText)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                       target:nil action:nil];
    
    self.toolbar.items = @[self.newTabButton, flexibleSpace, self.copyButton, flexibleSpace, self.settingsButton];
    [self.view addSubview:self.toolbar];
}

- (void)newTerminalSession {
    if (!self.isConnected) {
        [self.session connectToLocalShell];
        self.isConnected = YES;
    }
}

- (void)showSettings {
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)copyTerminalText {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"请通过点击终端区域后选择文本来复制"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    [alertView show];
}

@end
