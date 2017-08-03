//
//  SelectGYMViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/25/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectGYMViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIActionSheetDelegate>{
    
    __weak IBOutlet UISearchBar *gymSearchBar;
    __weak IBOutlet UITableView *gymTableview;
    IBOutlet UIView *navView;
    
    NSArray *lstGym;
}

- (IBAction)onGYMMenuClick:(id)sender;

@end
