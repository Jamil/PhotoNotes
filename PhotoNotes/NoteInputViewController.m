//
//  NoteInputViewController.m
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "NoteInputViewController.h"
#import "DetailViewController.h"

@interface NoteInputViewController ()

@end

@implementation NoteInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.topicInput becomeFirstResponder];
    self.navigationController.view.tintColor = self.presentingViewController.navigationController.view.tintColor;
    self.imageView.image = self.image;
    self.topicInput.placeholder = @"Lecture Topic";
    self.topicInput.delegate = self;
    self.datePicker.date = [NSDate date];
    self.datePicker.minuteInterval = 30;
    self.datePicker.maximumDate = [NSDate date];
    
    self.topicInput.floatingLabelFont = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
    self.topicInput.floatingLabelYPadding = @5;
    self.topicInput.font = [UIFont fontWithName:@"AvenirNext-Regular" size:40];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
}

-(void)donePressed:(id)sender {
    [self.delegate didReceiveData:self.topicInput.text withDate:self.datePicker.date andImage:self.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.delegate didReceiveData:self.topicInput.text withDate:self.datePicker.date andImage:self.image];
    [self dismissViewControllerAnimated:YES completion:nil];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
