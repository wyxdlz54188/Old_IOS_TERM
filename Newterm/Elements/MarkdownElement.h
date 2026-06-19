//
//  MarkdownElement.h
//  MarkdownKit
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MarkdownConfiguration.h"

@protocol MarkdownElement <NSObject>

@optional
// 块级元素
- (BOOL)canHandleLine:(NSString *)line;
- (NSAttributedString *)parseLines:(NSArray *)lines atIndex:(NSInteger)index;
- (NSInteger)numberOfLinesToSkip:(NSArray *)lines atIndex:(NSInteger)index;

// 内联元素
- (NSMutableAttributedString *)parseInline:(NSMutableAttributedString *)attrString
                       withConfiguration:(MarkdownConfiguration *)configuration;

@end

// 基础元素类
@interface MarkdownElement : NSObject <MarkdownElement>

- (void)applyAttributes:(NSDictionary *)attributes
          toAttributedString:(NSMutableAttributedString *)attrString
              matchingPattern:(NSString *)pattern;

@end