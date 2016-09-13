//
//  ViewController.m
//  Flicks
//
//  Created by Abhishek Nayani on 9/12/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "FlicksViewController.h"
#import "MovieTableViewCell.h"
#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"


@interface FlicksViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBarItem;
@property (nonatomic) UIRefreshControl *refreshControl;


@end

@implementation FlicksViewController

- (void)setIcon:(NSString*)imageName {
    self.tabBarItem.image = [UIImage imageNamed:imageName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = self.tableView.backgroundColor;
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to refresh"];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self fetchData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)fetchData {
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@",
                           self.endpoint, apiKey];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    //NSLog(@"Response: %@", responseDictionary);
                                                    self.movies = responseDictionary[@"results"];
                                                    [self.tableView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    
    NSString *thumbnailUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w92%@", movie[@"poster_path"]];
    
    [cell.thumbnail setImageWithURL:[NSURL URLWithString:thumbnailUrl]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"MovieDetail"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        MovieDetailsViewController *vc = segue.destinationViewController;
        vc.movie = self.movies[indexPath.row];
    }
}

@end
