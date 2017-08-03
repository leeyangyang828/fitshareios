//
//  RepsCell.m
//  FitNectApp
//
//  Created by stepanekdavid on 11/2/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "RepsCell.h"

@implementation RepsCell
+ (RepsCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepsCell" owner:nil options:nil];
    RepsCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCurWorkoutsItem:(NSString *)rep
{
    _lblRep.text = rep;
    //_curDict = cityAndFoodItem;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
