//
//  ViewController.m
//  TestSk
//
//  Created by Abhishek Nayani on 10/28/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

#import "ViewController.h"
#import "V1ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *V1;
@property (weak, nonatomic) IBOutlet UIView *V2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    V1ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"V1ViewController"];

    
    //vc.view.frame = CGRectMake(0, 0, _V2.frame.size.width, _V2.frame.size.height);
    [self addChildViewController:vc];
    [self.V2 addSubview:vc.view];
    [vc didMoveToParentViewController:self];
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
