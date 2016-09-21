//
//  LoginViewController.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/19/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(UIButton *)sender {

    TwitterClient *twitterClient = TwitterClient.sharedInstance;
    [twitterClient login:^(User *user, NSError *error) {
        
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        
        /*
        [twitterClient homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            for (Tweet *tweet in tweets) {
                NSLog(@"Tweet: %@", tweet.text);
            }
        }];
         */

    }];
    
    
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
