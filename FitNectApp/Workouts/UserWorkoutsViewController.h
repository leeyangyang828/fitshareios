//
//  UserWorkoutsViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/27/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserWorkoutsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    __weak IBOutlet UILabel *lblUserName;
    __weak IBOutlet UITableView *profileWorkoutsTableview;
}

- (IBAction)onCloseClick:(id)sender;
@property (strong, nonatomic) NSString *usernameForWorkous;
@end
