//
//  MasterViewController.h
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/8/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseInputViewController.h"
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, CourseInputViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
 @property (nonatomic, retain) IBOutlet UIBarButtonItem *dropboxSettingsLabel;

@end