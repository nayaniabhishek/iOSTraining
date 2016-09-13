//
//  ViewController.m
//  tipCalculator
//
//  Created by Abhishek Nayani on 9/6/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tip Calculator";
    [self updateValues];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float prevBillAmt = [defaults floatForKey:@"lastBillAmount"];
    
    if (prevBillAmt) {
        int timestamp = (int) [defaults integerForKey:@"lastBillTime"];
        int now = [[NSDate date] timeIntervalSince1970];
        if (now < (timestamp + (60 * 10))) {
            self.billTextField.text = [NSString stringWithFormat:@"%0.2f", prevBillAmt];
        } else {
            [defaults removeObjectForKey:@"lastBillAmount"];
            
            // tableview dequuereusablecellwithidentifier
            // tableview indexpathforcell
        }
    }
    
    [self.billTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:[self.billTextField.text floatValue] forKey:@"lastBillAmount"];
    [defaults setInteger:[[NSDate date] timeIntervalSince1970] forKey:@"lastBillTime"];
    [defaults synchronize];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

- (IBAction)onValueChanged:(UISegmentedControl *)sender {
    [self updateValues];
}

- (IBAction)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int defaultTip = (int) [defaults integerForKey:@"defaultTipIndex"];
    
    self.tipControl.selectedSegmentIndex = defaultTip;
    
    [self updateValues];
}

- (void)updateValues {
    float billAmount = [self.billTextField.text floatValue];
    
    NSArray *tipValues = @[@(0.15), @(0.20), @(0.25)];
    float tipAmount = [tipValues[self.tipControl.selectedSegmentIndex] floatValue] * billAmount;
    
    float totalAmount = billAmount + tipAmount;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
    
}
@end
