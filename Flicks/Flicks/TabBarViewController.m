//
//  TabBarViewController.m
//  Flicks
//
//  Created by Abhishek Nayani on 9/12/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController () <UITabBarControllerDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    item.image = [[UIImage imageNamed:@"video.png"]
                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    NSLog(@"XXXXXXXXXXXXX");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
