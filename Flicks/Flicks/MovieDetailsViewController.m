//
//  MovieDetailsViewController.m
//  Flicks
//
//  Created by Abhishek Nayani on 9/12/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "YTPlayerView.h"
#import "PosterViewController.h"


@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteAvgLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapper;

@property (nonatomic) NSDictionary *movieDetail;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Movie: %@", self.movie);
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    [self.synopsisLabel sizeToFit];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *releaseDate = [dateFormatter dateFromString:self.movie[@"release_date"]];
    
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    self.yearLabel.text = [dateFormatter stringFromDate:releaseDate];
    
    self.playerView.hidden = true;
    self.closeButton.hidden = true;
    self.playButton.hidden = true;
    
    [self fetchData];
    
    NSString *posterUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", self.movie[@"poster_path"]];
    
    [self.posterImage setImageWithURL:[NSURL URLWithString:posterUrl]];

    CGRect frame = self.scrollView.frame;
    frame.size.height = self.synopsisLabel.frame.size.height + self.synopsisLabel.frame.origin.y + 10;
    self.scrollView.frame = frame;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 60 + self.scrollView.frame.origin.y + self.scrollView.frame.size.height);
    
}

- (void)fetchData {
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@&append_to_response=videos", self.movie[@"id"], apiKey];
    
    
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
                                                    self.movieDetail = responseDictionary;
                                                    
                                                    long runtime = [self.movieDetail[@"runtime"] longValue];
                                                    long minutes = runtime % 60;
                                                    long hours = (runtime - minutes) / 60;
                                                    self.runtimeLabel.text = [NSString stringWithFormat:@"%ld hr and %ld mins", hours, minutes];
                                                    self.voteAvgLabel.text = [NSString stringWithFormat:@"%.1f", [self.movieDetail[@"vote_average"] floatValue]];

                                                    NSArray *videos = self.movieDetail[@"videos"][@"results"];
                                                    if (videos.count > 0) {
                                                        self.playButton.hidden = false;
                                                    }
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

- (IBAction)onPlay:(UIButton *)sender {
    self.playerView.hidden = false;
    self.closeButton.hidden = false;
    [self.playerView loadWithVideoId:self.movieDetail[@"videos"][@"results"][0][@"key"]];
}

- (IBAction)onClose:(UIButton *)sender {
    self.playerView.hidden = true;
    self.closeButton.hidden = true;
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    NSLog(@"TAPPPP");
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PosterViewController *pvc = [segue destinationViewController];
    
    pvc.posterUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", self.movie[@"poster_path"]];
}


@end
