//
//  ImageViewerViewController.m
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "ImageViewerViewController.h"

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
    self.scrollView.maximumZoomScale = 7.0f;
    
	[self.scrollView setContentSize:CGSizeMake(image.size.width, image.size.height)];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(IBAction)shareItem:(id)sender {
    UIActivityViewController *shareControl = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image] applicationActivities:nil];
    [self presentViewController:shareControl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
