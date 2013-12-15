//
//  DropboxSIgninViewController.m
//  PhotoNotes
//
//  Created by Jamil Dhanani on 12/12/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "DropboxSigninViewController.h"
#import "config.h"

@interface DropboxSigninViewController ()

@end

@implementation DropboxSigninViewController

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
	// Do any additional setup after loading the view.
    [self identifyStateAndAccount];
    [self loadButtons];
}

-(void)identifyStateAndAccount {
    _account = [[DBAccountManager sharedManager] linkedAccount];
    if (_account)
        _currentState = LSLinked;
    else
        _currentState = LSUnlinked;
}

-(void)loadButtons {
    if (_currentState == LSLinked) {
        self.linkedLabel.text = @"Linked Account";
        // Set up sign out, label buttons
        self.signOutButton.hidden = NO;
        self.signinButton.hidden = YES;
        DBAccountInfo *accInfo = [_account info];
        self.nameLabel.hidden = NO;
        self.nameLabel.text = accInfo.displayName;
        
        if (accInfo.orgName)
            self.nameLabel.text = [self.nameLabel.text stringByAppendingString:[NSString stringWithFormat:@" %@", accInfo.orgName]];
    }
    else {
        self.linkedLabel.text = @"No Account Linked";
        // Set up sign out, label buttons
        self.signOutButton.hidden = YES;
        self.signinButton.hidden = NO;
        self.nameLabel.hidden = YES;    }
}

-(void)cancelPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signIn:(id)sender {
    [[DBAccountManager sharedManager] linkFromController:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signOut:(id)sender {
    [[[DBAccountManager sharedManager] linkedAccount] unlink];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
