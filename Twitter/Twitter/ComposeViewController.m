//
//  ComposeViewController.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/21/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UITextView *editBox;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User *currentUser = [User currentUser];
    
    self.nameLabel.text = currentUser.name;
    self.handleLabel.text = currentUser.screenname;
    [self.profileImage setImageWithURL:currentUser.profileUrl];
    
    [self.editBox becomeFirstResponder];
}

- (IBAction)onCancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTweetButton:(UIBarButtonItem *)sender {
    [[TwitterClient sharedInstance] sendTweetWithParams:nil text:self.editBox.text completion:^(NSString *tweetIdStr, NSError *error) {
        if (error) {
            NSLog(@"%@", [NSString stringWithFormat:@"Error sending tweet: %@", self.editBox.text]);
        } else {
            // set tweet id so it can be favorited
            NSLog(@"%@", [NSString stringWithFormat:@"Tweet successful, tweet id_str: %@", tweetIdStr]);
        }
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
