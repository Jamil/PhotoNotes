//
//  DropboxSIgninViewController.h
//  PhotoNotes
//
//  Created by Jamil Dhanani on 12/12/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>

@interface DropboxSigninViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView *descView;

-(IBAction)signIn:(id)sender;
-(IBAction)signOut:(id)sender;

@end
