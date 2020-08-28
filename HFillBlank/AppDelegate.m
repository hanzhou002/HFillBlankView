//
//  AppDelegate.m
//  HFillBlank
//
//  Created by xiangfeng hao on 2020/8/26.
//  Copyright © 2020 Hao Xiangfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController=[[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
