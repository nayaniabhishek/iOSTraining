//
//  AppDelegate.m
//  Flicks
//
//  Created by Abhishek Nayani on 9/12/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "AppDelegate.h"
#import "FlicksViewController.h"
#import "TabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *topRatedNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"MoviesNavigationController"];
    FlicksViewController *topRatedViewController = (FlicksViewController *)[topRatedNavigationController topViewController];
    topRatedViewController.endpoint = @"top_rated";
    [topRatedViewController setIcon:@"star"];
    //[topRatedViewController setTitle:@"Top Rated"];
    
    
    UINavigationController *nowPlayingNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"MoviesNavigationController"];
    FlicksViewController *nowPlayingController = (FlicksViewController *)[nowPlayingNavigationController topViewController];
    nowPlayingController.endpoint = @"now_playing";
    [nowPlayingController setIcon:@"video"];
    //[nowPlayingController setTitle:@"Now Playing"];
    
    
    TabBarViewController *tabBarController = [[TabBarViewController alloc] init];
    tabBarController.viewControllers = @[nowPlayingNavigationController, topRatedNavigationController];
    tabBarController.tabBar.tintColor = [UIColor blackColor];
    [[UITabBar appearance] setBarTintColor:nowPlayingController.view.backgroundColor];
    
    self.window.rootViewController = tabBarController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
