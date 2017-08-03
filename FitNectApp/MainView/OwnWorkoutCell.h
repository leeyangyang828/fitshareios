//
//  OwnWorkoutCell.h
//  FitNectApp
//
//  Created by stepanekdavid on 12/12/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnWorkoutCell : UITableViewCell
+ (OwnWorkoutCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSDictionary *)workoutsItem;
@property (weak, nonatomic) IBOutlet UIImageView *workoutImage;
@property (weak, nonatomic) IBOutlet UILabel *workoutName;
@end
