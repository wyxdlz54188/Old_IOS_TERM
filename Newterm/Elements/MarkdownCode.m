//
//  MarkdownCode.m
//  MarkdownKit
//

#import "MarkdownCode.h"

@implementation MarkdownCode

- (BOOL)canHandleLine:(NSString *)line {
    return [line hasPrefix:@"    "] || [line hasPrefix:@"\t"];
}

- (NSAttributedString *)parseLines:(NSArray *)lines atIndex:(NSInteger)index {
    // 收集所有连续的代码行
    NSMutableString *codeBlock = [NSMutableString string];
    NSInteger i = index;
    
    while (i < lines.count) {
        NSString *line = lines[i];
        if ([line hasPrefix:@"    "] || [line hasPrefix:@"\t"]) {
            // 移除缩进
            NSString *trimmed = line;
            while ([trimmed hasPrefix:@" "] || [trimmed hasPrefix:@"\t"]) {
                trimmed = [trimmed substringFromIndex:1];
            }
            [codeBlock appendString:trimmed];
            if (i < lines.count - 1) {
                [codeBlock appendString:@"\n"];
            }
            i++;
        } else {
            break;
        }
    }
    
    if (codeBlock.length > 0) {
        UIFont *codeFont = [UIFont fontWithName:@"Courier" size:13];
        if (!codeFont) codeFont = [UIFont systemFontOfSize:13];
        
        NSDictionary *attributes = @{
            NSFontAttributeName: codeFont,
            NSForegroundColorAttributeName: [UIColor darkGrayColor],
            NSBackgroundColorAttributeName: [UIColor colorWithWhite:0.95 alpha:1.0],
            @"MDElementType": @"code-block"
        };
        
        return [[NSAttributedString alloc] initWithString:codeBlock attributes:attributes];
    }
    
    return nil;
}

- (NSInteger)numberOfLinesToSkip:(NSArray *)lines atIndex:(NSInteger)index {
    NSInteger count = 1;
    NSInteger i = index + 1;
    
    while (i < lines.count) {
        NSString *line = lines[i];
        if ([line hasPrefix:@"    "] || [line hasPrefix:@"\t"]) {
            count++;
            i++;
        } else {
            break;
        }
    }
    
    return count;
}

@end