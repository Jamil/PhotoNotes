//
//  CourseInputViewController.m
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/8/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "CourseInputViewController.h"

@interface CourseInputViewController ()

@end

@implementation CourseInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        CGRect viewBounds = [self.view bounds];
        viewBounds.origin.y = 18;
        viewBounds.size.height = viewBounds.size.height - 18;
    }
    
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.view.tintColor = self.presentingViewController.navigationController.view.tintColor;
    [self.courseNameLabel becomeFirstResponder];
    
    self.courseNameLabel.placeholder = @"Course Name";
    self.courseCodeLabel.placeholder = @"Course Code";
    
    self.courseCodeLabel.floatingLabelFont = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
    self.courseNameLabel.floatingLabelFont = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
    self.courseCodeLabel.floatingLabelYPadding = @5;
    self.courseNameLabel.floatingLabelYPadding = @5;
    self.courseCodeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:40];
    self.courseNameLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:40];
}

-(IBAction)doneButtonTapped {
    [self.delegate didReceiveInput:self.courseNameLabel.text code:self.courseCodeLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
