//
//  RepsEditCell.m
//  FitNectApp
//
//  Created by stepanekdavid on 11/9/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "RepsEditCell.h"

@implementation RepsEditCell

+ (RepsEditCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepsEditCell" owner:nil options:nil];
    RepsEditCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCurWorkoutsItem:(NSString *)rep
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
