//
//  MarkdownParser.h
//  MarkdownKit
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MarkdownConfiguration.h"

@interface MarkdownParser : NSObject

@property (nonatomic, strong) MarkdownConfiguration *configuration;

- (id)initWithConfiguration:(MarkdownConfiguration *)configuration;
- (NSAttributedString *)parse:(NSString *)markdown;

@end