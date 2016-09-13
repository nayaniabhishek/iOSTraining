//
//  MovieDetailsViewController.m
//  Flicks
//
//  Created by Abhishek Nayani on 9/12/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"


@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Movie: %@", self.movie);
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.yearLabel.text = self.movie[@"release_date"];
    
    NSString *posterUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", self.movie[@"poster_path"]];
    
    [self.posterImage setImageWithURL:[NSURL URLWithString:posterUrl]];
    
    [self.synopsisLabel sizeToFit];
    
    CGRect frame = self.scrollView.frame;
    frame.size.height = self.synopsisLabel.frame.size.height + self.synopsisLabel.frame.origin.y + 10;
    self.scrollView.frame = frame;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 60 + self.scrollView.frame.origin.y + self.scrollView.frame.size.height);
    
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
