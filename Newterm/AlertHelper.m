#import <UIKit/UIKit.h>
#import "AlertHelper.h"

@implementation AlertHelper

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
            viewController:(UIViewController *)vc {
    // 默认无回调
    [self showAlertWithTitle:title message:message viewController:vc okHandler:nil];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
            viewController:(UIViewController *)vc
                okHandler:(void(^)(void))okHandler {
    // 使用运行时判断是否存在 UIAlertController（iOS 8+）
    Class AlertControllerClass = NSClassFromString(@"UIAlertController");
    Class AlertActionClass = NSClassFromString(@"UIAlertAction");
    if (AlertControllerClass && AlertActionClass) {
        // 创建 UIAlertController
        id alert = [AlertControllerClass alertControllerWithTitle:title
                                                          message:message
                                                   preferredStyle:0]; // UIAlertControllerStyleAlert = 0
        // 创建 OK 按钮
        id ok = [AlertActionClass actionWithTitle:NSLocalizedString(@"OK", nil)
                                            style:0 // UIAlertActionStyleDefault = 0
                                          handler:^(id _Nonnull action) {
            if (okHandler) okHandler();
        }];
        // 添加按钮并展示
        [alert addAction:ok];
        // UIAlertController 直接继承自 UIViewController，安全地做强制转型
        [vc presentViewController:(UIViewController *)alert animated:YES completion:nil];
    } else {
        // iOS 6/7 使用 UIAlertView（已废弃）
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        #pragma clang diagnostic pop
        // UIAlertView 没有回调，手动调用
        if (okHandler) okHandler();
    }
}

@end