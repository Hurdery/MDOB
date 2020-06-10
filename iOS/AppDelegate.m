//
//  AppDelegate.m
//  iOS
//
//  Created by LY_MD on 2020/6/8.
//  Copyright © 2020 LY_MD. All rights reserved.
//

#import "AppDelegate.h"
#import "ListenVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    sleep(3);
    
    self.window.rootViewController = [ListenVC new];

    return YES;
}



@end
