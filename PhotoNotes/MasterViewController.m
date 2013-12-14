//
//  MasterViewController.m
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/8/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import <Dropbox/Dropbox.h>
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "DropboxController.h"

#import "config.h"

#define TB_CELL_BG_ALPHA 0.2f

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    DBAccountManager* accountMgr =
    [[DBAccountManager alloc] initWithAppKey:KEY secret:SECRET];
    [DBAccountManager setSharedManager:accountMgr];
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    if (!account) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"asked-connect"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect to Dropbox"
                                                            message:@"This application is designed for syncing with Dropbox. You may still use the application without connecting to Dropbox, but you will not be able to access your files outside of your phone. Would you like to connect?"
                                                           delegate:self
                                                    cancelButtonTitle:@"No Thanks" otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
    [DropboxController updateDropboxModelWithManagedObjectContext:self.managedObjectContext];
    
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"user pressed OK");
        [[DBAccountManager sharedManager] linkFromController:self];
    }
    else {
        NSLog(@"User pressed Cancel");
    }
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"asked-connect"];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.view.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    self.navigationController.toolbarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)insertNewObject:(id)sender
{
    CourseInputViewController *cinput = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseInputVC"];
    [cinput setDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cinput];
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)didReceiveInput:(NSString*)courseName code:(NSString*)courseCode {
    NSArray *colors = @[[UIColor colorWithRed:0.27f green:0.85f blue:0.46f alpha:TB_CELL_BG_ALPHA], [UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:TB_CELL_BG_ALPHA], [UIColor colorWithRed:1.0f green:0.79f blue:0.28f alpha:TB_CELL_BG_ALPHA], [UIColor colorWithRed:1.0f green:0.17f blue:0.34f alpha:TB_CELL_BG_ALPHA], [UIColor colorWithRed:1.0f green:0.22f blue:0.22f alpha:TB_CELL_BG_ALPHA], [UIColor colorWithRed:1.0f green:0.58f blue:0.21f alpha:TB_CELL_BG_ALPHA], [UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:TB_CELL_BG_ALPHA]];
    UIColor *shadeColor = colors[rand() % colors.count];
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:shadeColor];
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    NSManagedObject *newCourse = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [newCourse setValue:courseName forKey:@"name"];
    [newCourse setValue:courseCode forKey:@"code"];
    [newCourse setValue:colorData forKey:@"color"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.detailViewController.detailItem = object;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"code" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIView *bg = [[UIView alloc] init];
    UIColor *rawColor = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:[object valueForKey:@"color"]];
    bg.backgroundColor = rawColor;
    cell.backgroundView = bg;
    
    CGColorRef color = [rawColor CGColor];
    long int numComponents = CGColorGetNumberOfComponents(color);
    CGFloat red = 0.0f, green = 0.0f, blue = 0.0f;
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        red = components[0];
        green = components[1];
        blue = components[2];
    }
    
    UIColor *selectedColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    UIView *bg_select = [[UIView alloc] init];
    bg_select.backgroundColor = selectedColor;
    
    cell.selectedBackgroundView = bg_select;
    
    UILabel *mainLabel = (UILabel *)[cell viewWithTag:100];
    mainLabel.text = [[object valueForKey:@"code"] description];
    UILabel *secLabel = (UILabel *)[cell viewWithTag:200];
    secLabel.text = [[object valueForKey:@"name"] description];
}

@end
