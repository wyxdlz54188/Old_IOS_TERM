//
//  MarkdownList.m
//  MarkdownKit
//

#import "MarkdownList.h"

@implementation MarkdownList

- (BOOL)canHandleLine:(NSString *)line {
    return [line hasPrefix:@"- "] || [line hasPrefix:@"* "] ||
           [line rangeOfString:@"^\\d+\\. " options:NSRegularExpressionSearch].location != NSNotFound;
}

- (NSAttributedString *)parseLines:(NSArray *)lines atIndex:(NSInteger)index {
    NSString *line = lines[index];
    NSString *content = nil;
    NSString *prefix = @"";
    
    if ([line hasPrefix:@"- "] || [line hasPrefix:@"* "]) {
        content = [line substringFromIndex:2];
        prefix = @"• ";
    } else {
        // 数字列表
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d+\\. "
                                                                               options:0
                                                                                 error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:line
                                                        options:0
                                                          range:NSMakeRange(0, line.length)];
        if (match) {
            content = [line substringFromIndex:match.range.length];
            prefix = [line substringWithRange:match.range];
        }
    }
    
    if (content) {
        NSMutableString *resultString = [NSMutableString stringWithString:prefix];
        [resultString appendString:content];
        
        NSDictionary *attributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:14],
            NSForegroundColorAttributeName: [UIColor blackColor],
            @"MDElementType": @"list-item"
        };
        
        return [[NSAttributedString alloc] initWithString:resultString attributes:attributes];
    }
    
    return nil;
}

- (NSInteger)numberOfLinesToSkip:(NSArray *)lines atIndex:(NSInteger)index {
    return 1;
}

@end