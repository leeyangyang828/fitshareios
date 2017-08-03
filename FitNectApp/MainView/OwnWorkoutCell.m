//
//  OwnWorkoutCell.m
//  FitNectApp
//
//  Created by stepanekdavid on 12/12/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "OwnWorkoutCell.h"

@implementation OwnWorkoutCell
+ (OwnWorkoutCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OwnWorkoutCell" owner:nil options:nil];
    OwnWorkoutCell *cell = [array objectAtIndex:0];
    
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
