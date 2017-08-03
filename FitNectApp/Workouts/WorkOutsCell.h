//
//  WorkOutsCell.h
//  FitNect
//
//  Created by stepanekdavid on 7/26/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WorkOutsCellDelegate

@optional;
- (void)didComments:(NSString *)workoutsDict;
@end
@interface WorkOutsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtExercise;
@property (weak, nonatomic) IBOutlet UILabel *txtReps;
@property (weak, nonatomic) IBOutlet UILabel *txtSets;
@property (nonatomic, retain) NSString *curDict;
@property (weak, nonatomic) id<WorkOutsCellDelegate> resDelegate;
+ (WorkOutsCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSDictionary *)workoutsItem;
- (IBAction)onComments:(id)sender;

@property (nonatomic, assign, getter = isExpandable) BOOL expandable;
@property (nonatomic, assign, getter = isExpanded) BOOL expanded;

- (void)addIndicatorView;
- (void)removeIndicatorView;
- (BOOL)containsIndicatorView;
- (void)accessoryViewAnimation;

@end
