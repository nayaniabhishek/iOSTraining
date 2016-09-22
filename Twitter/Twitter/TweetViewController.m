//
//  TweetViewController.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/21/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = self.tweet.user.screenname;
    self.messageLabel.text = self.tweet.text;
    [self.profileImage setImageWithURL:self.tweet.user.profileUrl];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"M/d/yy, h:mm a"];
    self.timestampLabel.text = [dateFormat stringFromDate:self.tweet.timestamp];

    self.retweetLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.retweetCount];
    self.favLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.favoriteCount];
    
    [self highlightButton:self.retweetButton highlight:self.tweet.retweeted];
    [self highlightButton:self.favoriteButton highlight:self.tweet.favorited];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onReplyButton:(UIButton *)sender {
}

- (IBAction)onRetweetButton:(UIButton *)sender {
    [self.tweet retweet];
    self.retweetLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.retweetCount];
    [self highlightButton:self.retweetButton highlight:self.tweet.retweeted];
}

- (IBAction)onFavButton:(UIButton *)sender {
    BOOL favorited = [self.tweet favorite];
    
    self.tweet.favorited = favorited;
    
    self.favLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.favoriteCount];
    [self highlightButton:self.favoriteButton highlight:favorited];

}

- (void)highlightButton:(UIButton *)button highlight:(BOOL)highlight {
    if (highlight) {
        [button setSelected:YES];
    } else {
        [button setSelected:NO];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"replyTweetSegue"]) {
        ComposeViewController *vc = [segue destinationViewController];
        vc.replyToTweet = self.tweet;
    }
}


@end
