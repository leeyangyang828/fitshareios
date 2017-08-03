//
//  MyWorkoutsListViewController.h
//  FitNectApp
//
//  Created by stepanekdavid on 12/29/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWorkoutsListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UIView *navView;
    __weak IBOutlet UILabel *emptyLaberForWorkouts;
    __weak IBOutlet UITableView *MyWorkoutsTableView;
}

- (IBAction)onAddWorkouts:(id)sender;
- (IBAction)onMenu:(id)sender;
- (IBAction)onBack:(id)sender;
@end
