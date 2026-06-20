#import "MTAppDelegate.h"
#import "MTController.h"
#import "MTSettingsController.h"

static UIImage* createTerminalIcon() {
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(30,30),NO,0);

  // 深色背景
  [[UIColor colorWithWhite:0.15 alpha:1] setFill];
  [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(1,1,28,28) cornerRadius:6] fill];

  // 绿色 >_ 文字
  [[UIColor colorWithRed:0.3 green:0.85 blue:0.3 alpha:1] setFill];
  [@">_" drawAtPoint:CGPointMake(5,5) withFont:[UIFont fontWithName:@"Courier-Bold" size:18]];

  UIImage* img=UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

static UIImage* createSettingsIcon() {
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(30,30),NO,0);

  CGFloat cx=15,cy=15,outerR=13,innerR=9;

  UIBezierPath* gear=[UIBezierPath bezierPath];
  NSInteger teeth=8;

  for(NSInteger i=0;i<teeth;i++){
    CGFloat a=i*M_PI*2/teeth-M_PI/2;
    CGFloat sa=a-0.15,ea=a+0.15;
    CGFloat innerX1=cx+cosf(sa)*innerR,innerY1=cy+sinf(sa)*innerR;
    CGFloat innerX2=cx+cosf(ea)*innerR,innerY2=cy+sinf(ea)*innerR;
    CGFloat outerX1=cx+cosf(sa)*outerR,outerY1=cy+sinf(sa)*outerR;
    CGFloat outerX2=cx+cosf(ea)*outerR,outerY2=cy+sinf(ea)*outerR;

    if(i==0){
      [gear moveToPoint:CGPointMake(innerX1,innerY1)];
      [gear addLineToPoint:CGPointMake(outerX1,outerY1)];
    }
    [gear addLineToPoint:CGPointMake(outerX2,outerY2)];
    [gear addLineToPoint:CGPointMake(innerX2,innerY2)];

    CGFloat na=i*M_PI*2/teeth-M_PI/2+M_PI/teeth;
    CGFloat niX=cx+cosf(na)*innerR,niY=cy+sinf(na)*innerR;
    [gear addQuadCurveToPoint:CGPointMake(niX,niY)
                 controlPoint:CGPointMake(cx+cosf(na-M_PI/teeth*0.5)*(innerR+1),
                                          cy+sinf(na-M_PI/teeth*0.5)*(innerR+1))];
  }
  [gear closePath];

  [[UIColor colorWithWhite:0.55 alpha:1] setFill];
  [gear fill];

  UIBezierPath* center=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(cx-4,cy-4,8,8)];
  [[UIColor colorWithWhite:0.35 alpha:1] setFill];
  [center fill];

  UIBezierPath* dot=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(cx-2,cy-2,4,4)];
  [[UIColor colorWithWhite:0.6 alpha:1] setFill];
  [dot fill];

  UIImage* img=UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

@implementation MTAppDelegate

-(void)applicationDidFinishLaunching:(UIApplication*)application {
  window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

  controller=[[MTController alloc] init];
  controller.title=@"Term";
  
  UIImage* termIcon=createTerminalIcon();
  UITabBarItem* termItem=[[UITabBarItem alloc] initWithTitle:@"Term" image:nil tag:0];
  if([termItem respondsToSelector:@selector(setFinishedSelectedImage:withFinishedUnselectedImage:)]){
    [termItem setFinishedSelectedImage:termIcon withFinishedUnselectedImage:termIcon];
  }
  controller.tabBarItem=termItem;
  [termItem release];

  // ✅ 修改：设置页嵌入 NavigationController
  MTSettingsController* settingsController=[[MTSettingsController alloc] init];
  settingsController.title=@"设置";
  
  UINavigationController* settingsNav=[[UINavigationController alloc] initWithRootViewController:settingsController];
  settingsNav.navigationBar.barStyle=UIBarStyleDefault;
  [settingsController release];
  
  UIImage* settingsIcon=createSettingsIcon();
  UITabBarItem* settingsItem=[[UITabBarItem alloc] initWithTitle:@"设置" image:nil tag:1];
  if([settingsItem respondsToSelector:@selector(setFinishedSelectedImage:withFinishedUnselectedImage:)]){
    [settingsItem setFinishedSelectedImage:settingsIcon withFinishedUnselectedImage:settingsIcon];
  }
  settingsNav.tabBarItem=settingsItem;
  [settingsItem release];

  tabBarController=[[UITabBarController alloc] init];
  tabBarController.viewControllers=[NSArray arrayWithObjects:controller,settingsNav,nil];
  [settingsNav release];

  window.rootViewController=tabBarController;
  [tabBarController release];
  [window makeKeyAndVisible];
}

-(BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  return [controller handleOpenURL:URL];
}

-(void)applicationDidEnterBackground:(UIApplication*)application {
  if(!controller.isRunning){exit(0);}
}

-(UIWindow*)window {
  return window;
}

-(void)dealloc {
  [window release];
  [controller release];
  [super dealloc];
}

@end