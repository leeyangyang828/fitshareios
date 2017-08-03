//
//  ExerciseCell.m
//  FitNectApp
//
//  Created by stepanekdavid on 8/23/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "ExerciseCell.h"

@implementation ExerciseCell
+ (ExerciseCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ExerciseCell" owner:nil options:nil];
    ExerciseCell *cell = [array objectAtIndex:0];
    
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
- (void)setItem:(NSString *)str
{
    _curExerciseName = str;
}
- (IBAction)onSearchHelping:(id)sender {
    [_delegate searchHelping:_curExerciseName];
}
@end
