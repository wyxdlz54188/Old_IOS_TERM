//
//  MarkdownConfiguration.m
//  MarkdownKit
//

#import "MarkdownConfiguration.h"

@implementation MarkdownConfiguration

+ (instancetype)defaultConfiguration {
    MarkdownConfiguration *config = [[MarkdownConfiguration alloc] init];
    config.defaultFont = [UIFont systemFontOfSize:14];
    config.defaultColor = [UIColor blackColor];
    config.linkColor = [UIColor blueColor];
    config.codeBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    config.quoteColor = [UIColor grayColor];
    config.headerFontSizeMultiplier = 1.5;
    return config;
}

@end