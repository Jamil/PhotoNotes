//
//  DropboxController.h
//  CourseNotes
//
//  Created by Jamil Dhanani on 11/9/2013.
//  Copyright (c) 2013 Jamil Dhanani. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreData/CoreData.h>

@interface DropboxController : NSObject

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
-(void)updateDropboxModel;

+(void)updateDropboxModelWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end