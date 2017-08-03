//
//  MyWorkOutViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/25/15.
//  Copyright © 2015 jella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWorkOutViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UISearchBarDelegate>{
    IBOutlet UIView *navView;
    
    __weak IBOutlet UITableView *WorkoutsFromDBTableView;
    __weak IBOutlet UISearchBar *workoutsSearchBar;
    
    __weak IBOutlet UIImageView *currentProfileImageview;
    __weak IBOutlet UIButton *btnFilterType;
}

- (IBAction)onMyWorkoutMenu:(id)sender;
- (IBAction)onFileteredWorkouts:(id)sender;

- (IBAction)onBack:(id)sender;
@property NSInteger type;
@end
