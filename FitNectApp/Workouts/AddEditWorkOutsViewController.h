//
//  AddEditWorkOutsViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/26/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SKSTableView.h"
@interface AddEditWorkOutsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIScrollViewDelegate, SKSTableViewDelegate>{
    __weak IBOutlet UITextField *txtExercise;
    __weak IBOutlet UITextField *txtSets;
    IBOutlet UIView *navView;
    
    __weak IBOutlet UISwitch *selectedRepsSets;
    
    NSArray *lstHelpForExercise;
    BOOL isShared;
    
    __weak IBOutlet UIView *commentPreView;
    __weak IBOutlet UILabel *lblSelectedComment;
    
    __weak IBOutlet UILabel *lblTypeCardio;
    __weak IBOutlet UILabel *lblWorkoutsName;
    
}
@property (weak, nonatomic) IBOutlet SKSTableView *AddOfCurrentUserTableView;

@property (weak, nonatomic) IBOutlet UITableView *helpForExerciseTableView;

- (IBAction)onAdd:(id)sender;
- (IBAction)onSelectedRepsSets:(id)sender;

- (IBAction)onCommentPreviewClose:(id)sender;
@property (strong, nonatomic) NSMutableDictionary *arrAddWorkouts;
@property (strong, nonatomic) NSString *workoutsImageUrl;
@property (strong, nonatomic) NSString *workoutName;
@property (strong, nonatomic) NSString *workoutType;
@end
