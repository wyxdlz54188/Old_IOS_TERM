//
//  MarkdownParser.m
//  MarkdownKit
//

#import "MarkdownParser.h"
#import "MarkdownElement.h"
#import "MarkdownHeader.h"
#import "MarkdownList.h"
#import "MarkdownQuote.h"
#import "MarkdownCode.h"
#import "MarkdownLink.h"
#import "MarkdownImage.h"
#import "MarkdownHorizontalRule.h"
#import "NSString+Markdown.h"

@interface MarkdownParser ()

@property (nonatomic, strong) NSArray *blockElements;
@property (nonatomic, strong) NSArray *inlineElements;

@end

@implementation MarkdownParser

- (id)init {
    return [self initWithConfiguration:[MarkdownConfiguration defaultConfiguration]];
}

- (id)initWithConfiguration:(MarkdownConfiguration *)configuration {
    self = [super init];
    if (self) {
        _configuration = configuration;
        [self setupElements];
    }
    return self;
}

- (void)setupElements {
    // 块级元素
    self.blockElements = @[
        [[MarkdownHeader alloc] init],
        [[MarkdownList alloc] init],
        [[MarkdownQuote alloc] init],
        [[MarkdownCode alloc] init],
        [[MarkdownHorizontalRule alloc] init]
    ];
    
    // 内联元素（注意顺序：先处理链接和图片）
    self.inlineElements = @[
        [[MarkdownImage alloc] init],
        [[MarkdownLink alloc] init]
    ];
}

- (NSAttributedString *)parse:(NSString *)markdown {
    if (!markdown) return [[NSAttributedString alloc] initWithString:@""];
    
    // 1. 先处理块级元素
    NSArray *lines = [markdown componentsSeparatedByString:@"\n"];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    NSInteger i = 0;
    while (i < lines.count) {
        NSString *line = lines[i];
        
        BOOL handled = NO;
        for (id<MarkdownElement> element in self.blockElements) {
            if ([element canHandleLine:line]) {
                NSAttributedString *parsed = [element parseLines:lines atIndex:i];
                if (parsed) {
                    [result appendAttributedString:parsed];
                    // 跳转行数
                    i += [element numberOfLinesToSkip:lines atIndex:i];
                    handled = YES;
                    break;
                }
            }
        }
        
        if (!handled) {
            // 普通段落
            NSAttributedString *paragraph = [self parseParagraph:line];
            [result appendAttributedString:paragraph];
            if (i < lines.count - 1) {
                [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
            i++;
        }
    }
    
    return result;
}

- (NSAttributedString *)parseParagraph:(NSString *)line {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:line];
    
    // 默认样式
    [attrString addAttribute:NSFontAttributeName
                       value:self.configuration.defaultFont
                       range:NSMakeRange(0, line.length)];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:self.configuration.defaultColor
                       range:NSMakeRange(0, line.length)];
    
    // 处理内联元素
    for (id<MarkdownElement> element in self.inlineElements) {
        attrString = [element parseInline:attrString withConfiguration:self.configuration];
    }
    
    return attrString;
}

@end