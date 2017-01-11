//
//  V1ViewController.m
//  TestSk
//
//  Created by Abhishek Nayani on 10/28/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

#import "V1ViewController.h"


@interface V1ViewController ()

@property (nonatomic) SKStoreProductViewController *storeViewController;
@end

@implementation V1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.definesPresentationContext = YES;
    
    self.storeViewController = [[SKStoreProductViewController alloc] init];
    
    self.storeViewController.delegate = self;
    
    NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier:[NSNumber numberWithInteger:327630330]};
    
    [self.storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                       
                                       NSLog(@"ERROR:: %@", error);
                                       
                                   }];
    
    // [storeViewController.view addSubview:_videoView];
    //[_videoView setFrame:CGRectMake(0.0f, 0.0f, storeViewController.view.frame.size.width, storeViewController.view.frame.size.height)];
    
    self.storeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.storeViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:self.storeViewController animated:YES completion:nil];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self.storeViewController dismissViewControllerAnimated:YES completion:nil];
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
