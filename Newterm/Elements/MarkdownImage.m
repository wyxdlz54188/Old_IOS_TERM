//
//  MarkdownImage.m
//  MarkdownKit
//

#import "MarkdownImage.h"

@implementation MarkdownImage

- (NSMutableAttributedString *)parseInline:(NSMutableAttributedString *)attrString
                        withConfiguration:(MarkdownConfiguration *)configuration {
    NSString *pattern = @"!\\[([^\\]]*)\\]\\(([^)]*)\\)";

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

        NSRange urlRange = [match rangeAtIndex:2];
        NSString *url = [string substringWithRange:urlRange];
        NSRange altRange = [match rangeAtIndex:1];
        NSString *alt = [string substringWithRange:altRange];
        if (alt.length == 0) alt = @"Image";

        NSDictionary *attributes = @{
            NSFontAttributeName: [UIFont italicSystemFontOfSize:configuration.defaultFont.pointSize],
            NSForegroundColorAttributeName: [UIColor grayColor],
            @"MDImageURL": url,
            @"MDImageAlt": alt,
            @"MDElementType": @"image"
        };

        NSString *replacement = [NSString stringWithFormat:@"[%@]", alt];
        NSMutableAttributedString *replacementAttr = [[NSMutableAttributedString alloc] initWithString:replacement
                                                                                            attributes:attributes];

        [attrString replaceCharactersInRange:match.range withAttributedString:replacementAttr];
    }

    return attrString;
}

@end
