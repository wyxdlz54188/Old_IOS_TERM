#import "MTSettingsController.h"

@interface MTSettingsController () {
  UISlider* fontSizeSlider;
  UILabel* fontSizeLabel;
}
@end

@implementation MTSettingsController

-(void)loadView {
  [self setTitle:@"\u8bbe\u7f6e"];

  UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
  view.backgroundColor = [UIColor groupTableViewBackgroundColor];
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view = view;
  [view release];

  CGFloat y = 20;
  CGFloat w = view.bounds.size.width;

  UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w-40, 30)];
  titleLabel.text = @"\u7ec8\u7aef\u5b57\u4f53\u5927\u5c0f";
  titleLabel.font = [UIFont boldSystemFontOfSize:16];
  titleLabel.textColor = [UIColor blackColor];
  titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [view addSubview:titleLabel];
  [titleLabel release];
  y += 35;

  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  NSString* name = [NSBundle mainBundle].bundleIdentifier;
  NSDictionary* settings = [defaults persistentDomainForName:name];
  CGFloat currentSize = [[settings objectForKey:@"fontSize"] respondsToSelector:@selector(doubleValue)] ?
    [[settings objectForKey:@"fontSize"] doubleValue] : 10;
  if(currentSize <= 0) currentSize = 10;

  fontSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w-40, 25)];
  fontSizeLabel.text = [NSString stringWithFormat:@"%.0f pt", currentSize];
  fontSizeLabel.font = [UIFont systemFontOfSize:14];
  fontSizeLabel.textColor = [UIColor darkGrayColor];
  fontSizeLabel.textAlignment = NSTextAlignmentCenter;
  fontSizeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [view addSubview:fontSizeLabel];
  y += 30;

  fontSizeSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, y, w-80, 30)];
  fontSizeSlider.minimumValue = 6;
  fontSizeSlider.maximumValue = 24;
  fontSizeSlider.value = currentSize;
  fontSizeSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [fontSizeSlider addTarget:self action:@selector(fontSizeChanged:) forControlEvents:UIControlEventValueChanged];
  [view addSubview:fontSizeSlider];
  [fontSizeSlider release];

  UILabel* minLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 30, 30)];
  minLabel.text = @"6";
  minLabel.font = [UIFont systemFontOfSize:11];
  minLabel.textColor = [UIColor grayColor];
  minLabel.textAlignment = NSTextAlignmentCenter;
  [view addSubview:minLabel];
  [minLabel release];

  UILabel* maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(w-40, y, 30, 30)];
  maxLabel.text = @"24";
  maxLabel.font = [UIFont systemFontOfSize:11];
  maxLabel.textColor = [UIColor grayColor];
  maxLabel.textAlignment = NSTextAlignmentCenter;
  maxLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  [view addSubview:maxLabel];
  [maxLabel release];
}

-(void)fontSizeChanged:(UISlider*)slider {
  CGFloat fontSize = round(slider.value);
  fontSizeLabel.text = [NSString stringWithFormat:@"%.0f pt", fontSize];

  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  NSString* name = [NSBundle mainBundle].bundleIdentifier;
  NSMutableDictionary* settings = [[defaults persistentDomainForName:name] mutableCopy];
  if(!settings) settings = [[NSMutableDictionary alloc] init];
  [settings setObject:[NSNumber numberWithDouble:fontSize] forKey:@"fontSize"];
  [defaults setPersistentDomain:settings forName:name];
  [settings release];
}

@end
