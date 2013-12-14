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
}

-(void)signIn:(id)sender {
    DBAccountManager* accountMgr =
    [[DBAccountManager alloc] initWithAppKey:KEY secret:SECRET];
    [DBAccountManager setSharedManager:accountMgr];
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    if (!account) {
        [[DBAccountManager sharedManager] linkFromController:self];
    }
}

-(void)signOut:(id)sender {
    [[[DBAccountManager sharedManager] linkedAccount] unlink];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
