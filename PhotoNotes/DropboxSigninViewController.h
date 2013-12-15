//
//  DropboxSIgninViewController.h
//  PhotoNotes
//
//  Created by Jamil Dhanani on 12/12/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>

typedef enum LinkedState {
    LSLinked, LSUnlinked
} LinkedState;

@interface DropboxSigninViewController : UIViewController {
    bool _currentState;
    DBAccount *_account;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *linkedLabel;
@property (nonatomic, retain) IBOutlet UIButton *signOutButton;
@property (nonatomic, retain) IBOutlet UIButton *signinButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

-(IBAction)signIn:(id)sender;
-(IBAction)signOut:(id)sender;
-(IBAction)cancelPress:(id)sender;

@end
