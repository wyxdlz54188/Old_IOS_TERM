//
//  MarkdownTable.m
//  MarkdownKit
//

#import "MarkdownTable.h"

@implementation MarkdownTable

- (BOOL)canHandleLine:(NSString *)line {
    NSString *trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [trimmed hasPrefix:@"|"];
}

- (NSAttributedString *)parseLines:(NSArray *)lines atIndex:(NSInteger)index {
    NSMutableArray *rows = [NSMutableArray array];
    NSInteger i = index;
    NSInteger headerCount = 0;
    BOOL hasHeader = NO;
    BOOL hasSeparator = NO;
    
    while (i < (NSInteger)lines.count) {
        NSString *line = lines[i];
        NSString *trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (![trimmed hasPrefix:@"|"]) break;
        
        NSArray *cells = [self parseCells:trimmed];
        
        if (cells.count == 0) break;
        
        if (rows.count == 0) {
            headerCount = cells.count;
            [rows addObject:cells];
        } else if (!hasSeparator && [self isSeparatorRow:cells]) {
            hasSeparator = YES;
            hasHeader = YES;
            [rows addObject:cells];
        } else {
            if (cells.count > headerCount) {
                cells = [cells subarrayWithRange:NSMakeRange(0, headerCount)];
            }
            while (cells.count < headerCount) {
                cells = [cells arrayByAddingObject:@""];
            }
            [rows addObject:cells];
        }
        
        i++;
    }
    
    if (rows.count == 0) return nil;
    
    NSInteger dataStart = hasHeader ? 2 : 0;
    if (dataStart >= (NSInteger)rows.count) return nil;
    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<table>"];
    
    if (hasHeader) {
        NSArray *headerRow = rows[0];
        [html appendString:@"<thead><tr>"];
        for (NSString *cell in headerRow) {
            [html appendFormat:@"<th>%@</th>", [self escapeHTML:cell]];
        }
        [html appendString:@"</tr></thead>"];
    }
    
    [html appendString:@"<tbody>"];
    for (NSInteger r = dataStart; r < (NSInteger)rows.count; r++) {
        NSArray *row = rows[r];
        [html appendString:@"<tr>"];
        for (NSString *cell in row) {
            [html appendFormat:@"<td>%@</td>", [self escapeHTML:cell]];
        }
        [html appendString:@"</tr>"];
    }
    [html appendString:@"</tbody></table>"];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:html];
    [result addAttribute:@"MDElementType" value:@"table" range:NSMakeRange(0, html.length)];
    return result;
}

- (NSInteger)numberOfLinesToSkip:(NSArray *)lines atIndex:(NSInteger)index {
    NSInteger count = 0;
    NSInteger i = index;
    
    while (i < (NSInteger)lines.count) {
        NSString *trimmed = [lines[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![trimmed hasPrefix:@"|"]) break;
        count++;
        i++;
    }
    
    return count;
}

- (NSArray *)parseCells:(NSString *)line {
    if (![line hasPrefix:@"|"]) return @[];
    
    NSString *inner = [line substringFromIndex:1];
    if ([inner hasSuffix:@"|"]) {
        inner = [inner substringToIndex:inner.length - 1];
    }
    
    NSArray *parts = [inner componentsSeparatedByString:@"|"];
    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:parts.count];
    
    for (NSString *part in parts) {
        [cells addObject:[part stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    
    return cells;
}

- (BOOL)isSeparatorRow:(NSArray *)cells {
    if (cells.count == 0) return NO;
    for (NSString *cell in cells) {
        NSString *trimmed = [cell stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (trimmed.length == 0) continue;
        for (NSInteger i = 0; i < (NSInteger)trimmed.length; i++) {
            unichar c = [trimmed characterAtIndex:i];
            if (c != '-' && c != ':' && c != ' ') return NO;
        }
    }
    return YES;
}

- (NSString *)escapeHTML:(NSString *)text {
    if (text.length == 0) return @"";
    text = [text stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    text = [text stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    text = [text stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return text;
}

@end
