//
//  MarkdownElement.m
//  MarkdownKit
//

#import "MarkdownElement.h"

@implementation MarkdownElement

- (void)applyAttributes:(NSDictionary *)attributes
        toAttributedString:(NSMutableAttributedString *)attrString
            matchingPattern:(NSString *)pattern {
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    if (error) return;
    
    NSString *string = attrString.string;
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, string.length)];
    
    for (NSInteger i = matches.count - 1; i >= 0; i--) {
        NSTextCheckingResult *match = matches[i];
        if (match.numberOfRanges < 2) continue;
        
        NSRange contentRange = [match rangeAtIndex:1];
        NSString *content = [string substringWithRange:contentRange];
        
        NSMutableAttributedString *replacement = [[NSMutableAttributedString alloc] initWithString:content];
        [replacement addAttributes:attributes range:NSMakeRange(0, content.length)];
        
        // 保留原有颜色
        UIColor *color = [attrString attribute:NSForegroundColorAttributeName
                                       atIndex:match.range.location
                                effectiveRange:NULL];
        if (color) {
            [replacement addAttribute:NSForegroundColorAttributeName
                                value:color
                                range:NSMakeRange(0, content.length)];
        }
        
        [attrString replaceCharactersInRange:match.range
                        withAttributedString:replacement];
    }
}

@end