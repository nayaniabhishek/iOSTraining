//
//  HamburgerViewController.m
//  Twitter
//
//  Created by Abhishek Nayani on 9/20/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "HamburgerViewController.h"
#import "TweetsViewController.h"
#import "MenuCell.h"
#import "LogoutCell.h"
#import "User.h"

@interface HamburgerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerXConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) UIViewController *tweetsViewController;
@property (nonatomic) UIViewController *profileViewController;
@property (nonatomic) UIViewController *mentionsViewController;
@property (nonatomic) UIViewController *currentViewController;
@property (nonatomic) NSArray *viewControllers;
@end

@implementation HamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    self.tweetsViewController = [storyboard instantiateViewControllerWithIdentifier:@"TweetsNavigationController"];
    self.profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileNavigationController"];
    self.mentionsViewController = [storyboard instantiateViewControllerWithIdentifier:@"TweetsNavigationController"];
    
    self.mentionsViewController.navigationController.title = @"Mentions";
    
    TweetsViewController *mentions = (TweetsViewController*)self.mentionsViewController.presentedViewController;
    mentions.mentionsUI = YES;
    
    // set tweets view as initial view
    self.currentViewController = self.tweetsViewController;
    self.currentViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.currentViewController.view];
    
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    [self addChildViewController:contentViewController];
    contentViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:contentViewController.view];
    [contentViewController didMoveToParentViewController:self];
}


- (void)viewDidLayoutSubviews {
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self.tableView dequeueReusableCellWithIdentifier:@"LogoutCell"];
    }
    
    MenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    switch (indexPath.row) {
        case 1:
            cell.menuLabel.text = @"Profile";
            cell.menuIcon.image = [UIImage imageNamed:@"profile"];
            break;
        case 2:
            cell.menuLabel.text = @"Timeline";
            cell.menuIcon.image = [UIImage imageNamed:@"timeline"];
            break;
        case 3:
            cell.menuLabel.text = @"Mentions";
            cell.menuIcon.image = [UIImage imageNamed:@"mentions"];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Did call row %ld", indexPath.row);
    if (indexPath.row == 0) {
        [User logout];
    } else if (indexPath.row == 1) {
        [self setContentViewController:self.profileViewController];
    } else if (indexPath.row == 2) {
        [self setContentViewController:self.tweetsViewController];
    } else {
        [self setContentViewController:self.mentionsViewController];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.containerXConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];

}

- (IBAction)onSignout:(id)sender {
    [User logout];
}

- (IBAction)onSwipeRight:(UISwipeGestureRecognizer *)sender {
    [UIView animateWithDuration:.30 animations:^{
        self.containerXConstraint.constant = 130;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)onSwipeLeft:(UISwipeGestureRecognizer *)sender {
    [UIView animateWithDuration:.30 animations:^{
        self.containerXConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
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
