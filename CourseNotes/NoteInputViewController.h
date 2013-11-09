//
//  NoteInputViewController.h
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

@protocol NoteInputViewControllerDelegate <NSObject>

-(void)didReceiveData:(NSString*)topic withDate:(NSDate*)date andImage:(UIImage*)image;

@end

@interface NoteInputViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) id<NoteInputViewControllerDelegate> delegate;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet JVFloatLabeledTextField *topicInput;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

-(IBAction)donePressed:(id)sender;
-(IBAction)cancelButtonTapped;

@end
