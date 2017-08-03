//
//  OneWorkouksCurrentUserViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/27/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneWorkouksCurrentUserViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>{
    
    __weak IBOutlet UITableView *workoutsFromFireBaseTableview;
    __weak IBOutlet UILabel *lblWorkoutsName;
    
    __weak IBOutlet UIView *noteView;
}

@property (weak, nonatomic) IBOutlet UILabel *lblComments;
- (IBAction)onCloseClick:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *infoSelectedWorkOuts;
@end
