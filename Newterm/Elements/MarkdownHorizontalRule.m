//
//  MarkdownHorizontalRule.m
//  MarkdownKit
//

#import "MarkdownHorizontalRule.h"

@implementation MarkdownHorizontalRule

- (BOOL)canHandleLine:(NSString *)line {
    NSString *trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmed.length < 3) return NO;

    unichar firstChar = [trimmed characterAtIndex:0];
    if (firstChar != '-' && firstChar != '*' && firstChar != '_') return NO;

    for (NSInteger i = 0; i < trimmed.length; i++) {
        if ([trimmed characterAtIndex:i] != firstChar) return NO;
    }

    return YES;
}

- (NSAttributedString *)parseLines:(NSArray *)lines atIndex:(NSInteger)index {
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:12],
        NSForegroundColorAttributeName: [UIColor lightGrayColor],
        @"MDElementType": @"hr"
    };

    return [[NSAttributedString alloc] initWithString:@"\n───\n" attributes:attributes];
}

- (NSInteger)numberOfLinesToSkip:(NSArray *)lines atIndex:(NSInteger)index {
    return 1;
}

@end
