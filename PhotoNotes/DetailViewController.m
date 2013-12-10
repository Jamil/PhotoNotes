//
//  DetailViewController.m
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/8/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageViewerViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    NSData *colorData = [self.detailItem valueForKey:@"color"];
    UIColor *rawColor = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
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
    UIColor *tintToSet = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];

    self.navigationController.view.tintColor = tintToSet;
    // Update the user interface for the detail item.
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:@selector(takePhoto:)];
    [cameraButton setAction:@selector(takePhoto:)];
    [cameraButton setTarget:self];
    
    self.navigationItem.rightBarButtonItem = cameraButton;
    self.navigationController.toolbarHidden = YES;
}

-(void)takePhoto:(id)sender {
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (void)viewDidLoad
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"name"] description];
    }
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)didReceiveData:(NSString*)topic withDate:(NSDate*)date andImage:(UIImage*)image {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    NSManagedObject *newNote = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [newNote setValue:date forKey:@"timestamp"];
    [newNote setValue:topic forKey:@"topic"];
    
    // Write to file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *second = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [self.detailItem valueForKey:@"code"]]];

    if (![[NSFileManager defaultManager] fileExistsAtPath:second])
        [[NSFileManager defaultManager] createDirectoryAtPath:second withIntermediateDirectories:0 attributes:@{} error:nil];
    
    NSString *first = [second stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", topic]];
    int count = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[first stringByAppendingPathExtension:@"jpg"]]) {
        count++;
        NSString *toCheck = [first stringByAppendingString:[NSString stringWithFormat:@"-%d", count]];
        toCheck = [toCheck stringByAppendingPathExtension:@"jpg"];
        while ([[NSFileManager defaultManager] fileExistsAtPath:toCheck]) {
            count++;
            toCheck = [first stringByAppendingString:[NSString stringWithFormat:@"-%d", count]];
            toCheck = [toCheck stringByAppendingPathExtension:@"jpg"];
        }
    }
    
    NSString *appFile;
    if (!count) {
        // append jpg and add
        appFile = [first stringByAppendingPathExtension:@"jpg"];
    }
    else {
        appFile = [first stringByAppendingString:[NSString stringWithFormat:@"-%d", count]];
        appFile = [appFile stringByAppendingPathExtension:@"jpg"];
    }
    
    NSLog(@"Writing to %@", appFile);
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:appFile options:NSAtomicWrite error:nil];
    
    [newNote setValue:appFile forKey:@"imagePath"];
    [newNote setValue:self.detailItem forKey:@"courseParent"];
    NSLog(@"Saving with course parent %@", [self.detailItem valueForKey:@"name"]);
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Sync to Dropbox
    [DropboxController updateDropboxModelWithManagedObjectContext:self.managedObjectContext];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    [picker dismissViewControllerAnimated:YES completion:^{
        NoteInputViewController *ninput = [self.storyboard instantiateViewControllerWithIdentifier:@"NoteInputVC"];
        [ninput setDelegate:self];
        self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        ninput.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ninput];
        [self presentViewController:navigationController animated:YES completion:nil];
    }];
    
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        // Row selected
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ImageViewSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(courseParent.name == %@)", [self.detailItem valueForKey:@"name"]];
    [fetchRequest setPredicate:predicate];
    
    NSLog(@"Predicate checks for %@", [self.detailItem valueForKey:@"name"]);
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *fetchedObjs = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSLog(@"%@", [fetchedObjs description]);
    
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
    UILabel *mainLabel = (UILabel *)[cell viewWithTag:100];
    mainLabel.text = [[object valueForKey:@"topic"] description];
    
    NSDate *date = [object valueForKey:@"timestamp"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:usLocale];
    
    UILabel *secLabel = (UILabel *)[cell viewWithTag:200];
    secLabel.text = [dateFormatter stringFromDate:date];
}




@end
