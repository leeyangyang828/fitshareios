//
//  WorkoutsOfUsersCell.m
//  FitNectApp
//
//  Created by stepanekdavid on 8/23/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "WorkoutsOfUsersCell.h"

@implementation WorkoutsOfUsersCell
+ (WorkoutsOfUsersCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WorkoutsOfUsersCell" owner:nil options:nil];
    WorkoutsOfUsersCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setCurWorkoutsItem:(NSDictionary *)workoutsItem
{
    
}

@end
