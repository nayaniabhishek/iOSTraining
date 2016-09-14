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
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"


@interface FlicksViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBarItem;
@property (nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UILabel *networkErrorLabel;
@property (nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSelector;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) NSMutableArray *filteredList;

@end

@implementation FlicksViewController

- (void)setIcon:(NSString*)imageName {
    self.tabBarItem.image = [UIImage imageNamed:imageName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    self.navigationItem.leftBarButtonItem = searchBarItem;
    self.searchBar.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.networkErrorLabel.hidden = true;
    
    [self.view addSubview:self.tableView];
    
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

- (void)viewDidLayoutSubviews {
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
}

- (IBAction)changeView:(id)sender {
    UIView *fromView, *toView;
    
    if (self.tableView.superview == self.view) {
        fromView = self.tableView;
        toView = self.collectionView;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        [self.collectionView reloadData];
        
    } else {
        fromView = self.collectionView;
        toView = self.tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        [self.tableView reloadData];
    }
    
    [fromView removeFromSuperview];
    
    toView.frame = self.view.bounds;
    [self.view addSubview:toView];
    
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
                                                    self.networkErrorLabel.hidden = false;
                                                }
                                            }];
    [task resume];
    [self.refreshControl endRefreshing];
}


- (void)fetchSearchData {
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/search/movie?api_key=%@&query=%@",
                           apiKey, self.searchBar.text];
    
    
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
                                                    self.networkErrorLabel.hidden = false;
                                                }
                                            }];
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.filteredList) {
        return self.filteredList.count;
    } else {
        return self.movies.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie;
    if (self.filteredList) {
        movie = self.filteredList[indexPath.row];
    } else {
        movie = self.movies[indexPath.row];
    }
    
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
        
    } else if ([[segue identifier] isEqualToString:@"MovieCellDetail"]) {
        UICollectionViewCell *cell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        
        MovieDetailsViewController *vc = segue.destinationViewController;
        vc.movie = self.movies[indexPath.row];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.filteredList) {
        return self.filteredList.count;
    } else {
        return self.movies.count;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    
    NSDictionary *movie;
    if (self.filteredList) {
        movie = self.filteredList[indexPath.row];
    } else {
        movie = self.movies[indexPath.row];
    }
    
    NSString *thumbnailUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w92%@", movie[@"poster_path"]];
    
    [cell.poster setImageWithURL:[NSURL URLWithString:thumbnailUrl]];
    
    return cell;
 
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
    
    self.filteredList = [[NSMutableArray alloc] init];
    
    for (id movie in self.movies) {
        if ([movie[@"title"] rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [self.filteredList addObject:movie];
        }
    }
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setText:@""];
    [searchBar endEditing:YES];
    
    self.filteredList = nil;
    [self.tableView reloadData];
    [self.collectionView reloadData];
}


@end
