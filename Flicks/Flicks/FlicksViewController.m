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

@interface FlicksViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray* movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation FlicksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //self.navigationController.visibleViewController.title = @"TTTTTTT";
    self.title = @"Playing Now";
    
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString =
    [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
    
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
                                                    NSLog(@"Response: %@", responseDictionary);
                                                    self.movies = responseDictionary[@"results"];
                                                    [self.tableView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];
    
    
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
