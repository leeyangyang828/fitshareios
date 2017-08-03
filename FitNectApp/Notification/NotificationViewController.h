//
//  NotificationViewController.h
//  FitNectApp
//
//  Created by stepanekdavid on 11/10/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{

    __weak IBOutlet UITableView *NotificationTableView;
}

@end
