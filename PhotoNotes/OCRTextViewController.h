//
//  OCRTextViewController.h
//  PhotoNotes
//
//  Created by Jamil Dhanani on 12/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCRTextViewController : UIViewController

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) IBOutlet UITextView *convertedText;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *av;
@property (nonatomic, retain) IBOutlet UILabel *workingLabel;
@end
