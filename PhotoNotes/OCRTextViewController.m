//
//  OCRTextViewController.m
//  PhotoNotes
//
//  Created by Jamil Dhanani on 12/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "OCRTextViewController.h"
#import "Tesseract.h"

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
    Tesseract *tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    
    if (!self.image) {
        NSLog(@"Warning: No Image in OCR VC");
        return;
    }
    
    [tesseract setImage:self.image];
    
    [self.av startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [tesseract recognize];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.convertedText.text = [tesseract recognizedText];
            [tesseract clear];
            [self.av stopAnimating];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
