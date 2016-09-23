//
//  ProfileViewController.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/21/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "User.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) NSArray *tweets;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User *currentUser = self.selectedUser ? self.selectedUser : [User currentUser];
    
    self.nameLabel.text = currentUser.name;
    self.handleLabel.text = currentUser.screenname;
    self.tweetsLabel.text = [NSString stringWithFormat:@"%ld", currentUser.tweetCount];
    self.followingLabel.text = [NSString stringWithFormat:@"%ld", currentUser.friendCount];
    self.followersLabel.text = [NSString stringWithFormat:@"%ld", currentUser.followerCount];
    [self.profileImage setImageWithURL:currentUser.profileUrl];
    [self.bannerImage setImageWithURL:currentUser.bannerUrl];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = self.tableView.backgroundColor;
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to refresh"];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];

    [self refreshTweets];
}

- (void)refreshTweets {
    User *currentUser = self.selectedUser ? self.selectedUser : [User currentUser];
    [[TwitterClient sharedInstance] userTimelineWithParams:nil user:currentUser completion:^(NSArray *tweets, NSError *error) {
        NSLog(@"Profile:Refreshing tweets");
        if (error) {
            NSLog(@"Error getting timeline: %@", error);
        } else {
            NSLog(@"Got Tweets, refresh %lu", (unsigned long)tweets.count);
            self.tweets = tweets;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    [cell setTweet:self.tweets[indexPath.row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    static TweetCell *sizingCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sizingCell = (TweetCell*)[tableView dequeueReusableCellWithIdentifier: @"TweetCell"];
    });
    
    // configure the cell
    [sizingCell setTweet:self.tweets[indexPath.row]];
    
    // force layout
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    // get the fitting size
    CGSize s = [sizingCell.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
    NSLog( @"fittingSize: %@", NSStringFromCGSize( s ));
    
    return s.height;
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
