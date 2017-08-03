//
//  Workouts+CoreDataProperties.h
//  FitNectApp
//
//  Created by stepanekdavid on 8/24/16.
//  Copyright © 2016 lovisa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Workouts.h"

NS_ASSUME_NONNULL_BEGIN

@interface Workouts (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *data;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSNumber *typeWorkouts;

@end

NS_ASSUME_NONNULL_END
