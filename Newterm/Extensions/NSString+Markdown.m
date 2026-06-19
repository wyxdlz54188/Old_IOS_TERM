//
//  NSString+Markdown.m
//  MarkdownKit
//

#import "NSString+Markdown.h"
#import "MarkdownParser.h"

@implementation NSString (Markdown)

- (NSAttributedString *)markdownAttributedString {
    MarkdownParser *parser = [[MarkdownParser alloc] init];
    return [parser parse:self];
}

@end