//
//  WorkOutsViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/26/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOutsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UISearchBarDelegate>{
    
    __weak IBOutlet UITableView *workoutsTableView;
    __weak IBOutlet UISearchBar *workoutsSearchBar;
    IBOutlet UIView *navView;
}
- (IBAction)onWorkMenuClick:(id)sender;

- (IBAction)onBackClick:(id)sender;
@property (strong, nonatomic) NSMutableArray *arrWorkoutsFromFireBase;
@end
