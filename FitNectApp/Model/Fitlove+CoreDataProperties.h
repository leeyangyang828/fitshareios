//
//  Fitlove+CoreDataProperties.h
//  FitNectApp
//
//  Created by stepanekdavid on 8/24/16.
//  Copyright © 2016 lovisa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Fitlove.h"

NS_ASSUME_NONNULL_BEGIN

@interface Fitlove (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isFitLove;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *workoutsName;

@end

NS_ASSUME_NONNULL_END
