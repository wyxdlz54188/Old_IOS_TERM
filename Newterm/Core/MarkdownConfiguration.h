//
//  MarkdownConfiguration.h
//  MarkdownKit
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MarkdownConfiguration : NSObject

@property (nonatomic, strong) UIFont *defaultFont;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *linkColor;
@property (nonatomic, strong) UIColor *codeBackgroundColor;
@property (nonatomic, strong) UIColor *quoteColor;

// 字体大小配置
@property (nonatomic, assign) CGFloat headerFontSizeMultiplier;

+ (instancetype)defaultConfiguration;

@end