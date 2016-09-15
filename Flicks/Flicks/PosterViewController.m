//
//  PosterViewController.m
//  Flicks
//
//  Created by Abhishek Nayani on 9/15/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "PosterViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PosterViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:self.posterUrl]];
    
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.delegate=self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.posterImageView;
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
