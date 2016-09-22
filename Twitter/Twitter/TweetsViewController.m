//
//  TweetsViewController.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/20/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"

@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSArray *tweets;
@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self refreshTweets];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = self.tableView.backgroundColor;
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to refresh"];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];
    
    if (self.mentionsUI) {
        self.navigationController.title = @"Mentions";
    }
    
}

- (void)refreshTweets {
    if (self.mentionsUI) {
        [[TwitterClient sharedInstance] mentionsTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            NSLog(@"Refreshing tweets");
            if (error) {
                NSLog(@"Error getting timeline: %@", error);
            } else {
                NSLog(@"Got Tweets, refresh %lu", (unsigned long)tweets.count);
                self.tweets = tweets;
                [self.tableView reloadData];
            }
            [self.refreshControl endRefreshing];
        }];
        
    } else {
        [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            NSLog(@"Refreshing tweets");
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    NSLog(@"Tweet : %@", self.tweets[indexPath.row]);
    [cell setTweet:self.tweets[indexPath.row]];
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowTweetViewSegue"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        TweetViewController *vc = segue.destinationViewController;
        vc.tweet = self.tweets[indexPath.row];
    }
}


@end
