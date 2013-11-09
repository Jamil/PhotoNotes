//
//  Note.m
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import "Note.h"
#import "Course.h"
#import <Dropbox/Dropbox.h>

@implementation Note

@dynamic timestamp;
@dynamic imagePath;
@dynamic topic;
@dynamic courseParent;

- (void)prepareForDeletion
{
    [super prepareForDeletion];
    NSString* filename = [self.imagePath lastPathComponent];
    DBPath *toDelete = [[DBPath root] childPath:[NSString stringWithFormat:@"%@/%@", self.courseParent.code, filename]];
    
    if (![DBFilesystem sharedFilesystem]) {
        DBAccountManager *manager = [DBAccountManager sharedManager];
        DBAccount *account = manager.linkedAccount;
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
    [[DBFilesystem sharedFilesystem] deletePath:toDelete error:nil];
    
    [[NSFileManager defaultManager] removeItemAtPath:self.imagePath error:nil];
}

@end
