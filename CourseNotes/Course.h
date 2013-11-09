//
//  Course.h
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSData * color;
@property (nonatomic, retain) NSSet *notes;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
