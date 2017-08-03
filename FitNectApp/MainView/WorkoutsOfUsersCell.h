//
//  WorkoutsOfUsersCell.h
//  FitNectApp
//
//  Created by stepanekdavid on 8/23/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutsOfUsersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *workoutsName;
@property (weak, nonatomic) IBOutlet UILabel *matchedUsername;
@property (weak, nonatomic) IBOutlet UILabel *likesForworkouts;
@property (weak, nonatomic) IBOutlet UIImageView *workoutImg;
@property (nonatomic, strong) id delegate;
+ (WorkoutsOfUsersCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSDictionary *)workoutsItem;
@end
