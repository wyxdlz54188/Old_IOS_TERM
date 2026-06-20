//
//  MarkdownLink.m
//  MarkdownKit
//

#import "MarkdownLink.h"

@implementation MarkdownLink

- (NSMutableAttributedString *)parseInline:(NSMutableAttributedString *)attrString
                        withConfiguration:(MarkdownConfiguration *)configuration {
    NSString *pattern = @"\\[([^\\]]+)\\]\\(([^)]+)\\)";

    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    if (error) return attrString;

    NSString *string = attrString.string;
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, string.length)];

    for (NSInteger i = matches.count - 1; i >= 0; i--) {
        NSTextCheckingResult *match = matches[i];
        if (match.numberOfRanges < 3) continue;

        NSRange textRange = [match rangeAtIndex:1];
        NSString *text = [string substringWithRange:textRange];

        UIColor *linkColor = configuration.linkColor ?: [UIColor blueColor];
        NSDictionary *attributes = @{
            NSFontAttributeName: configuration.defaultFont,
            NSForegroundColorAttributeName: linkColor,
            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
        };

        NSMutableAttributedString *replacementAttr = [[NSMutableAttributedString alloc] initWithString:text
                                                                                            attributes:attributes];

        [attrString replaceCharactersInRange:match.range withAttributedString:replacementAttr];
    }

    return attrString;
}

@end
