//
//  ExerciseCell.h
//  FitNectApp
//
//  Created by stepanekdavid on 8/23/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ExerciseCellDelegate

@optional;
- (void)searchHelping:(NSString *)exercieName;
@end
@interface ExerciseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *helpExerciseName;
- (IBAction)onSearchHelping:(id)sender;
- (void)setItem:(NSString *)str;

@property (nonatomic, retain) NSString *curExerciseName;
@property (weak, nonatomic) id<ExerciseCellDelegate> delegate;
+ (UITableViewCell *)sharedCell;
@end
