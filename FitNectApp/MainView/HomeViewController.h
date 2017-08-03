//
//  HomeViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/25/15.
//  Copyright © 2015 jella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    IBOutlet UIView *navView;
    
    __weak IBOutlet UILabel *compledtedHomeNum;
    
    __weak IBOutlet UILabel *sharedHomeNum;
    
    
    __weak IBOutlet UIButton *currentUserProfileImge;
    __weak IBOutlet UIImageView *currentUserProfileImageView;
    __weak IBOutlet UILabel *trainerLevel;
    __weak IBOutlet UILabel *lblAboutMeGoal;
    
    __weak IBOutlet UILabel *currentEmail;
    __weak IBOutlet UILabel *currentUsername;
    __weak IBOutlet UIButton *btnMyGym;
    __weak IBOutlet UILabel *currentGoal;
    __weak IBOutlet UITextField *aboutMe;
    
    __weak IBOutlet UITableView *GoalTableView;
    
    __weak IBOutlet UIView *changedUserNameView;
    __weak IBOutlet UITextField *txtCurrentUsername;
    __weak IBOutlet UITextField *txtNewUsername;
    
    __weak IBOutlet UIView *changedEmailView;
    __weak IBOutlet UITextField *txtcurrentEmail;
    __weak IBOutlet UITextField *txtCurrentPassword;
    __weak IBOutlet UITextField *txtNewEmail;
    
}
- (IBAction)onHomeMenu:(id)sender;
- (IBAction)onViewProfile:(id)sender;
- (IBAction)onNotification:(id)sender;

- (IBAction)onChangeProfileImage:(id)sender;

- (IBAction)onSettingView:(id)sender;

- (IBAction)onSetGoal:(id)sender;
- (IBAction)onGym:(id)sender;

- (IBAction)onChangeEmail:(id)sender;
- (IBAction)onChangeUserName:(id)sender;


- (IBAction)onChangedUserName:(id)sender;
- (IBAction)onChangedUserNameClose:(id)sender;

- (IBAction)onChangedEmail:(id)sender;
- (IBAction)onChangedEmailClose:(id)sender;

- (IBAction)onGetFacebookFriendsList:(id)sender;
@end
