//
//  PreviewWorkOutsViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/26/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"

@interface PreviewWorkOutsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,SKSTableViewDelegate>{
    
    __weak IBOutlet SKSTableView *workoutsFromFireBaseTableview;
    IBOutlet UIView *navView;
    __weak IBOutlet UILabel *lblWorkoutsName;
    
    __weak IBOutlet UIButton *selectedWorkUsernamer;
    __weak IBOutlet UIView *noteView;
    __weak IBOutlet UILabel *lblComments;
    UIBarButtonItem *barButton2;
    
    __weak IBOutlet UIImageView *profileImage;
    __weak IBOutlet UILabel *lblLoveCounts;
    
    __weak IBOutlet UIView *tipViewWorkouts;
    __weak IBOutlet UIButton *tipViewCheckBtn;
    
}

- (IBAction)onFaveriteClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onNoteClick:(id)sender;
- (IBAction)onCloseClick:(id)sender;
- (IBAction)onPreviewMenu:(id)sender;
- (IBAction)onSelectedWorkUserName:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *infoSelectedWorkOuts;

- (IBAction)onTipViewClose:(id)sender;
- (IBAction)onCheckTipViewBtn:(id)sender;
@end
