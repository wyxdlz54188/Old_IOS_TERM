#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    // 普通白色背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 右上角完成按钮
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(dismissSettings)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 30)];
    titleLabel.text = @"NewTerm 设置";
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    // 信息标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width - 40, 200)];
    label.text = @"字体: Courier 14pt\n\n颜色: 绿色终端\n\nShell: /bin/bash\n\n版本: 1.0.0";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
}

- (void)dismissSettings {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end