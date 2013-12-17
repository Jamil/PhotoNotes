//
//  OCRTextViewController.m
//  PhotoNotes
//
//  Created by Jamil Dhanani on 12/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "OCRTextViewController.h"

@interface OCRTextViewController ()

@end

@implementation OCRTextViewController

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
	
    // Intialize Tesseract (actually that sounds extremely cool) and set IVs
    self.tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    
    if (!self.image) {
        NSLog(@"Warning: No Image in OCR VC");
        return;
    }
    
    [self.tesseract setImage:self.image];
    
    [self.av startAnimating];
    // Timeout after 20 seconds
    NSTimer *timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                             target:self
                                                           selector:@selector(ocrTimeout)
                                                           userInfo:nil
                                                            repeats:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.tesseract recognize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [timeoutTimer invalidate];
            self.workingLabel.hidden = TRUE;
            self.convertedText.text = [self.tesseract recognizedText];
            [self.tesseract clear];
            [self.av stopAnimating];
        });
    });
}

- (void)ocrTimeout {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error: Timeout" message:@"The text conversion process took a little too long and we had to stop it - this is usually an indication that the text was unreadable and couldn't be processed." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
    [self.av stopAnimating];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
