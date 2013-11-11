//
//  DropboxController.m
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "DropboxController.h"
#import <Dropbox/Dropbox.h>
#import "config.h"

@implementation DropboxController

-(instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    self = [super init];
    if (self) {
        self.managedObjectContext = managedObjectContext;
    }
    return self;
}

-(void)updateDropboxModel {
    // Fetch all courses
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *courses = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < courses.count; i++) {
        NSLog(@"%@", [[courses objectAtIndex:i] valueForKey:@"code"]);
        
        NSFetchRequest *notesRequest = [[NSFetchRequest alloc] init];
        [notesRequest setEntity:[NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(courseParent.code == %@)", [[courses objectAtIndex:i] valueForKey:@"code"]];
        [notesRequest setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *notes = [self.managedObjectContext executeFetchRequest:notesRequest error:&error];
        
        NSMutableArray *notePaths = [[NSMutableArray alloc] initWithCapacity:notes.count];
        for (int i = 0; i < notes.count; i++) {
            [notePaths addObject:[[notes objectAtIndex:i] valueForKey:@"imagePath"]];
        }
        
        [dict setObject:notePaths forKey:[[courses objectAtIndex:i] valueForKey:@"code"]];
    }
    
    NSLog(@"%@", [dict description]);
}

+(void)updateDropboxModelWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    // Fetch all courses
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:managedObjectContext]];
    
    NSError *error = nil;
    NSArray *courses = [managedObjectContext executeFetchRequest:request error:&error];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < courses.count; i++) {
        NSLog(@"%@", [[courses objectAtIndex:i] valueForKey:@"code"]);
        
        NSFetchRequest *notesRequest = [[NSFetchRequest alloc] init];
        [notesRequest setEntity:[NSEntityDescription entityForName:@"Note" inManagedObjectContext:managedObjectContext]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(courseParent.code == %@)", [[courses objectAtIndex:i] valueForKey:@"code"]];
        [notesRequest setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *notes = [managedObjectContext executeFetchRequest:notesRequest error:&error];
        
        NSMutableArray *notePaths = [[NSMutableArray alloc] initWithCapacity:notes.count];
        for (int i = 0; i < notes.count; i++) {
            [notePaths addObject:[[notes objectAtIndex:i] valueForKey:@"imagePath"]];
        }
        
        [dict setObject:notePaths forKey:[[courses objectAtIndex:i] valueForKey:@"code"]];
    }
    
    DBAccountManager *manager = [DBAccountManager sharedManager];
    DBAccount *account = manager.linkedAccount;
    
    if (account) {
        DBFilesystem *filesystem;
        if (![DBFilesystem sharedFilesystem]) {
            filesystem = [[DBFilesystem alloc] initWithAccount:account];
            [DBFilesystem setSharedFilesystem:filesystem];
        }
        else {
            filesystem = [DBFilesystem sharedFilesystem];
        }
        NSArray *courseNames = dict.allKeys;
        for (int i = 0; i < courseNames.count; i++) {
            DBPath *toCreate = [[DBPath root] childPath:[NSString stringWithFormat:@"%@", courseNames[i]]];
            [filesystem createFolder:toCreate error:nil];
            
            NSArray *imagesInFolder = [dict valueForKey:courseNames[i]];
            for (int j = 0; j < imagesInFolder.count; j++) {
                NSLog(@"TEST");
                NSString* filename = [[imagesInFolder objectAtIndex:j] lastPathComponent];
                DBPath *toInsertFile = [[DBPath root] childPath:[NSString stringWithFormat:@"%@/%@", courseNames[i], filename]];
                DBFile *file = [filesystem createFile:toInsertFile error:nil];
                NSData *data = [NSData dataWithContentsOfFile:[imagesInFolder objectAtIndex:j]];
                [file writeData:data error:nil];
            }
        }
    }
    
    NSLog(@"%@", [dict description]);
}

@end
