//
//  SettingViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/25/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController{
    
    __weak IBOutlet UILabel *currentEmail;
    __weak IBOutlet UILabel *currentUsername;
    __weak IBOutlet UIButton *btnMyGym;
    
    
    __weak IBOutlet UIView *changeEmailView;
    __weak IBOutlet UITextField *changeOldEmail;
    __weak IBOutlet UITextField *changeOldPassword;
    __weak IBOutlet UITextField *changeNewEmail;
    
    
    __weak IBOutlet UIView *changePasswordView;
    __weak IBOutlet UITextField *changeOldPwdForPV;
    __weak IBOutlet UITextField *changeNewPwdForPv;
    __weak IBOutlet UITextField *changeVerifyPwdForPV;
    
    __weak IBOutlet UILabel *currentGoal;
    __weak IBOutlet UITextField *aboutMe;
    
    __weak IBOutlet UITableView *GoalTableView;
    
    
}
- (IBAction)onCancelClick:(id)sender;
- (IBAction)onResetPasswordClick:(id)sender;
- (IBAction)onMyGymClick:(id)sender;
- (IBAction)onLogoutClick:(id)sender;
- (IBAction)onChangeEmail:(id)sender;

- (IBAction)onChangeEmailOfEmailView:(id)sender;
- (IBAction)onCancelOfEmailView:(id)sender;

- (IBAction)onChnagePasswordOfPwdview:(id)sender;
- (IBAction)onCancelOfPasswordView:(id)sender;

- (IBAction)onChangeGoal:(id)sender;

@end
