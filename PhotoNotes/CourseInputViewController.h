//
//  CourseInputViewController.h
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/8/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

@protocol CourseInputViewControllerDelegate <NSObject>

-(void)didReceiveInput:(NSString*)courseName code:(NSString*)courseCode;

@end

@interface CourseInputViewController : UIViewController

@property (nonatomic, retain) IBOutlet JVFloatLabeledTextField *courseNameLabel;
@property (nonatomic, retain) IBOutlet JVFloatLabeledTextField *courseCodeLabel;

@property (nonatomic, retain) id<CourseInputViewControllerDelegate> delegate;

-(IBAction)doneButtonTapped;
-(IBAction)cancelButtonTapped;

@end
