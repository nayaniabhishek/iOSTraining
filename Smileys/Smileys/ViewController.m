//
//  ViewController.m
//  Smileys
//
//  Created by Abhishek Nayani on 9/21/16.
//  Copyright © 2016 yahoo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *trayView;

@property (nonatomic, assign) CGPoint trayOriginalCenter;
@property (nonatomic, strong) UIImageView *newlyCreatedFace;

@property (nonatomic, assign) CGPoint smileyFaceImageCenter;
@property (nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.trayOriginalCenter = self.trayView.center;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onNewSmileyPan:(UIPanGestureRecognizer *)sender {
    NSLog(@"Panning New");
    UIImageView *imageView = (UIImageView *)sender.view;
    static CGPoint faceCenter;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        faceCenter = imageView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        imageView.center = CGPointMake(faceCenter.x + [sender translationInView:self.view].x, faceCenter.y + [sender translationInView:self.view].y);
    }
    
}


- (IBAction)onSmileyPan:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        // Gesture recognizers know the view they are attached to
        UIImageView *imageView = (UIImageView *)sender.view;
        
        // Create a new image view that has the same image as the one currently panning
        self.newlyCreatedFace = [[UIImageView alloc] initWithImage:imageView.image];
        
        // Add the new face to the tray's parent view.
        [self.view addSubview:self.newlyCreatedFace];
        
        // Initialize the position of the new face.
        self.newlyCreatedFace.center = imageView.center;
        
        // Since the original face is in the tray, but the new face is in the
        // main view, you have to offset the coordinates
        
        CGPoint faceCenter = self.newlyCreatedFace.center;
        self.newlyCreatedFace.center = CGPointMake(faceCenter.x,
                                                   faceCenter.y + self.trayView.frame.origin.y);
        self.smileyFaceImageCenter = self.newlyCreatedFace.center;
        
        self.newlyCreatedFace.userInteractionEnabled = YES;
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onNewSmileyPan:)];
        [self.newlyCreatedFace addGestureRecognizer:self.pan];
        
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        self.newlyCreatedFace.center = CGPointMake(self.smileyFaceImageCenter.x + [sender translationInView:self.trayView].x, self.smileyFaceImageCenter.y + [sender translationInView:self.trayView].y);
    }
    
}

- (IBAction)onTrayPanGestureRecognizer:(UIPanGestureRecognizer *)sender {
    NSLog(@"Panning");
    
    // Absolute (x,y) coordinates in parentView
    CGPoint location = [sender locationInView:self.trayView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(location));
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed at: %@", NSStringFromCGPoint(location));
        self.trayView.center = CGPointMake(self.trayOriginalCenter.x, self.trayOriginalCenter.y + [sender translationInView:self.trayView].y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended at: %@", NSStringFromCGPoint(location));
        
        if ([sender velocityInView:self.trayView].y > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.trayView.center = CGPointMake(self.trayOriginalCenter.x, 640);
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                self.trayView.center = CGPointMake(self.trayOriginalCenter.x, 450);
            }];
        }
    }
    
    
    
}

@end
