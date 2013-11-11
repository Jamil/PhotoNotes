//
//  Course.m
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "Course.h"
#import "Note.h"
#import <Dropbox/Dropbox.h>

@implementation Course

@dynamic name;
@dynamic code;
@dynamic color;
@dynamic notes;

- (void)prepareForDeletion
{
    [super prepareForDeletion];
    DBPath *toDelete = [[DBPath root] childPath:self.code];
    
    if (![DBFilesystem sharedFilesystem]) {
        DBAccountManager *manager = [DBAccountManager sharedManager];
        DBAccount *account = manager.linkedAccount;
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
    [[DBFilesystem sharedFilesystem] deletePath:toDelete error:nil];
}

@end
