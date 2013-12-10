//
//  ImageViewerViewController.m
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "ImageViewerViewController.h"
#import "OCRTextViewController.h"

@interface ImageViewerViewController ()

@end

@implementation ImageViewerViewController

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
    
    // Load image from file path
    NSString *imagePath = [self.detailItem valueForKey:@"imagePath"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:imagePath];
    UIImage *image = [UIImage imageWithData:data];
    self.imageView.image = image;
    [self.scrollView setDelegate:self];
    self.scrollView.maximumZoomScale = 4.0f;
    [self.imageView sizeToFit];
	[self.scrollView setContentSize:self.imageView.image.size];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = YES;
    
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = MAX(scaleWidth, scaleHeight);
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(IBAction)shareItem:(id)sender {
    UIActivityViewController *shareControl = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image] applicationActivities:nil];
    [self presentViewController:shareControl animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"OCRSegue"]) {
        OCRTextViewController *controller = [segue destinationViewController];
        controller.image = self.imageView.image;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
