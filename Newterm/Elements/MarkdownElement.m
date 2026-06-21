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
        
        NSMutableAttributedString *replacement = [[attrString attributedSubstringFromRange:contentRange] mutableCopy];
        [replacement addAttributes:attributes range:NSMakeRange(0, replacement.length)];
        
        [attrString replaceCharactersInRange:match.range
                        withAttributedString:replacement];
    }
}

@end