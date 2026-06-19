#import "MTAppDelegate.h"
#import "MTController.h"
#import "MTSettingsController.h"

@implementation MTAppDelegate

-(void)applicationDidFinishLaunching:(UIApplication*)application {
  window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

  controller=[[MTController alloc] init];
  controller.title=@"Term";
  controller.tabBarItem=[[[UITabBarItem alloc] 
    initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:0] autorelease];

  MTSettingsController* settingsController=[[MTSettingsController alloc] init];
  settingsController.title=@"设置";
  settingsController.tabBarItem=[[[UITabBarItem alloc] 
    initWithTabBarSystemItem:UITabBarSystemItemMore tag:1] autorelease];

  tabBarController=[[UITabBarController alloc] init];
  tabBarController.viewControllers=[NSArray arrayWithObjects:controller,settingsController,nil];
  [settingsController release];

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