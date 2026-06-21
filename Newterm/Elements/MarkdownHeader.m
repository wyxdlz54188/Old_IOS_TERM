//
//  MarkdownHeader.m
//  MarkdownKit
//

#import "MarkdownHeader.h"

@implementation MarkdownHeader

- (BOOL)canHandleLine:(NSString *)line {
    return [line hasPrefix:@"#"] && line.length > 1;
}

- (NSAttributedString *)parseLines:(NSArray *)lines atIndex:(NSInteger)index {
    NSString *line = lines[index];
    NSInteger level = 0;
    NSInteger i = 0;
    
    while (i < line.length && [line characterAtIndex:i] == '#') {
        level++;
        i++;
    }
    
    // 确保后面有空格
    if (i < line.length && [line characterAtIndex:i] == ' ') {
        NSString *content = [line substringFromIndex:i + 1];
        
        CGFloat fontSize = 24.0 - (level - 1) * 2.0;
        if (fontSize < 12) fontSize = 12;
        
        UIFont *headerFont = [UIFont boldSystemFontOfSize:fontSize];
        NSString *elementType = [NSString stringWithFormat:@"header-%ld", (long)level];
        NSDictionary *attributes = @{
            NSFontAttributeName: headerFont,
            NSForegroundColorAttributeName: [UIColor blackColor],
            @"MDElementType": elementType
        };
        
        return [[NSAttributedString alloc] initWithString:content attributes:attributes];
    }
    
    return nil;
}

- (NSInteger)numberOfLinesToSkip:(NSArray *)lines atIndex:(NSInteger)index {
    return 1;
}

@end