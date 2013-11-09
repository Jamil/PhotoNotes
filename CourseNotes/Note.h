//
//  Note.h
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * topic;
@property (nonatomic, retain) Course *courseParent;

@end
