//
//  MarkdownQuote.m
//  MarkdownKit
//

#import "MarkdownQuote.h"

@implementation MarkdownQuote

- (BOOL)canHandleLine:(NSString *)line {
    return [line hasPrefix:@"> "];
}

- (NSAttributedString *)parseLines:(NSArray *)lines atIndex:(NSInteger)index {
    NSString *line = lines[index];
    NSString *content = [line substringFromIndex:2];
    
    UIFont *italicFont = [UIFont italicSystemFontOfSize:14];
    NSDictionary *attributes = @{
        NSFontAttributeName: italicFont,
        NSForegroundColorAttributeName: [UIColor grayColor]
    };
    
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

- (NSInteger)numberOfLinesToSkip:(NSArray *)lines atIndex:(NSInteger)index {
    return 1;
}

@end