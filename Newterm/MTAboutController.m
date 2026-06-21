#import "MTAboutController.h"
#import "Core/MarkdownParser.h"
#import <CoreText/CoreText.h>

@interface MTAboutController () <UIWebViewDelegate>
@end

@implementation MTAboutController

- (void)loadView {
    [self setTitle:@"关于"];
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    [view release];
    
    // 创建 WebView 用于显示
    UIWebView *webView = [[UIWebView alloc] initWithFrame:view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.backgroundColor = [UIColor whiteColor];
    webView.opaque = YES;
    webView.scalesPageToFit = YES;
    webView.scrollView.bounces = YES;
    webView.scrollView.alwaysBounceVertical = YES;
    [view addSubview:webView];
    
    // 异步加载 Markdown
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mdContent = nil;
        NSURL *url = [NSURL URLWithString:@"http://wyxdlz54188.github.io/repo/debs/io.github.wyxdlz54188.oldterm/About.md"];
        mdContent = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        if (!mdContent) {
            mdContent = @"# NewTerm\n\n"
                         "iOS 6 终端模拟器，支持 VT100/xterm 控制序列。\n\n"
                         "---\n\n"
                         "## 功能特性\n\n"
                         "- 多窗口标签页管理\n"
                         "- 支持 SSH 连接\n"
                         "- 256 色调色板\n"
                         "- 自定义字体与字号\n"
                         "- Markdown 渲染引擎\n\n"
                         "---\n\n"
                         "## 版本信息\n\n"
                         "基于 MobileTerminal 改进，增加 Markdown 渲染、UTF-8 "
                         "多语言支持和现代化设置界面。";
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MarkdownParser *parser = [[MarkdownParser alloc] init];
            NSAttributedString *attributed = [parser parse:mdContent];
            NSString *html = [self htmlFromAttributedString:attributed];
            [webView loadHTMLString:html baseURL:nil];
            [parser release];
        });
    });
    
    [webView release];
}

- (NSString *)htmlFromAttributedString:(NSAttributedString *)attrString {
    NSMutableString *html = [NSMutableString string];
    
    [html appendString:@"<!DOCTYPE html><html><head><meta charset=\"utf-8\">"];
    [html appendString:@"<meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1\">"];
    [html appendString:@"<style>"];
    [html appendString:@"body{font-family:-apple-system,Helvetica;font-size:14px;color:#333;padding:16px;line-height:1.6;background:#fff}"];
    [html appendString:@"h1{font-size:24px;text-align:center;margin:16px 0}"];
    [html appendString:@"h2{font-size:18px;color:#555;margin:20px 0 10px}"];
    [html appendString:@"h3{font-size:16px;color:#555;margin:16px 0 8px}"];
    [html appendString:@"h4,h5,h6{font-size:14px;color:#555;margin:12px 0 6px}"];
    [html appendString:@"table{width:100%%;border-collapse:collapse;margin:10px 0}"];
    [html appendString:@"td,th{border:1px solid #ddd;padding:8px}"];
    [html appendString:@"th{background:#f5f5f5}"];
    [html appendString:@"code{background:#f0f0f0;padding:2px 6px;border-radius:3px;font-family:Courier,monospace}"];
    [html appendString:@"pre{background:#f5f5f5;padding:12px;border-radius:4px;overflow-x:auto;white-space:pre-wrap}"];
    [html appendString:@"pre code{background:none;padding:0}"];
    [html appendString:@"hr{border:none;border-top:1px solid #eee;margin:20px 0}"];
    [html appendString:@"a{color:#0366d6}"];
    [html appendString:@"img{max-width:100%%}"];
    [html appendString:@"blockquote{border-left:3px solid #ddd;padding:4px 12px;margin:12px 0;color:#666}"];
    [html appendString:@"ul,ol{padding-left:24px;margin:8px 0}"];
    [html appendString:@"li{margin:4px 0}"];
    [html appendString:@"p{margin:8px 0}"];
    [html appendString:@"</style></head><body>"];
    
    __block BOOL inParagraph = NO;
    __block BOOL inList = NO;
    
    void (^closeParagraph)(void) = ^{
        if (inParagraph) {
            [html appendString:@"</p>"];
            inParagraph = NO;
        }
    };
    
    void (^closeList)(void) = ^{
        if (inList) {
            [html appendString:@"</ul>"];
            inList = NO;
        }
    };
    
    [attrString enumerateAttributesInRange:NSMakeRange(0, attrString.length)
                                   options:0
                                usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSString *rawText = [attrString.string substringWithRange:range];
        NSString *tag = attrs[@"MDElementType"];
        
        if ([tag hasPrefix:@"header-"]) {
            closeParagraph();
            closeList();
            NSString *levelStr = [tag substringFromIndex:7];
            NSString *text = [self escapeHTML:rawText];
            [html appendFormat:@"<h%@>%@</h%@>", levelStr, text, levelStr];
            return;
        }
        
        if ([tag isEqualToString:@"hr"]) {
            closeParagraph();
            closeList();
            [html appendString:@"<hr>"];
            return;
        }
        
        if ([tag isEqualToString:@"list-item"]) {
            closeParagraph();
            if (!inList) {
                [html appendString:@"<ul>"];
                inList = YES;
            }
            NSString *text = [self formatInlineText:rawText withAttributes:attrs];
            [html appendFormat:@"<li>%@</li>", text];
            return;
        }
        
        if ([tag isEqualToString:@"code-block"]) {
            closeParagraph();
            closeList();
            NSString *text = [self escapeHTML:rawText];
            [html appendFormat:@"<pre><code>%@</code></pre>", text];
            return;
        }
        
        if ([tag isEqualToString:@"blockquote"]) {
            closeParagraph();
            closeList();
            NSString *text = [self formatInlineText:rawText withAttributes:attrs];
            [html appendFormat:@"<blockquote>%@</blockquote>", text];
            return;
        }
        
        if ([tag isEqualToString:@"table"]) {
            closeParagraph();
            closeList();
            [html appendString:rawText];
            return;
        }
        
        closeList();
        
        NSString *trimmed = [rawText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmed.length == 0) {
            closeParagraph();
            return;
        }
        
        if (!inParagraph) {
            [html appendString:@"<p>"];
            inParagraph = YES;
        }
        
        NSString *text = [self formatInlineText:rawText withAttributes:attrs];
        [html appendString:text];
    }];
    
    closeParagraph();
    closeList();
    
    [html appendString:@"</body></html>"];
    return html;
}

- (NSString *)formatInlineText:(NSString *)text withAttributes:(NSDictionary *)attrs {
    NSString *tag = attrs[@"MDElementType"];
    
    if ([tag isEqualToString:@"link"]) {
        NSString *url = attrs[@"MDLinkURL"] ?: @"#";
        NSString *escaped = [self escapeHTML:text];
        return [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", url, escaped];
    }
    
    if ([tag isEqualToString:@"image"]) {
        NSString *url = attrs[@"MDImageURL"] ?: @"";
        NSString *alt = attrs[@"MDImageAlt"] ?: @"";
        NSString *escapedURL = [self escapeHTML:url];
        NSString *escapedAlt = [self escapeHTML:alt];
        return [NSString stringWithFormat:@"<img src=\"%@\" alt=\"%@\">", escapedURL, escapedAlt];
    }
    
    NSString *escaped = [self escapeHTML:text];
    
    UIFont *font = attrs[NSFontAttributeName];
    if (font) {
        CTFontRef ctFont = (CTFontRef)font;
        CTFontSymbolicTraits traits = CTFontGetSymbolicTraits(ctFont);
        BOOL isBold = (traits & kCTFontBoldTrait) != 0;
        BOOL isItalic = (traits & kCTFontItalicTrait) != 0;
        
        if (isBold && isItalic) {
            return [NSString stringWithFormat:@"<b><i>%@</i></b>", escaped];
        } else if (isBold) {
            return [NSString stringWithFormat:@"<b>%@</b>", escaped];
        } else if (isItalic) {
            return [NSString stringWithFormat:@"<i>%@</i>", escaped];
        }
    }
    
    return escaped;
}

- (NSString *)escapeHTML:(NSString *)text {
    if (text.length == 0) return @"";
    text = [text stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    text = [text stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    text = [text stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return text;
}

@end