//
//  SettingViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/25/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SelectGYMViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;
@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>{
    NSArray *arrayGoal;
}

@end

@implementation SettingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    currentEmail.text = [NSString stringWithFormat:@"Email: %@", [AppDelegate sharedDelegate].userEmail];
    currentUsername.text = [NSString stringWithFormat:@"Username: %@", [AppDelegate sharedDelegate].userName];
    [btnMyGym setTitle:[NSString stringWithFormat:@"My Gym: %@", [AppDelegate sharedDelegate].currentGym] forState:UIControlStateNormal];
    
    changeEmailView.hidden = YES;
    changePasswordView.hidden = YES;
    
    GoalTableView.hidden = YES;
    
    arrayGoal = [[NSArray alloc] initWithObjects:@"Set Goal", @"Cardio Training", @"Crossfit",@"Sports Training",@"Strength Training",nil];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    if ([[AppDelegate sharedDelegate].goal isEqualToString:@""]) {
        currentGoal.text = @"Set Goal";
    }else{
        currentGoal.text = [AppDelegate sharedDelegate].goal;
    }
    aboutMe.text = [AppDelegate sharedDelegate].aboutMe;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onCancelClick:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onResetPasswordClick:(id)sender {
    [self.view endEditing:YES];
    changePasswordView.hidden = NO;
}

- (IBAction)onMyGymClick:(id)sender {
    [self.view endEditing:YES];
    [[AppDelegate sharedDelegate] gotToGYMSelected];
}

- (IBAction)onLogoutClick:(id)sender {
    
    [self.view endEditing:YES];
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        // Sign-out succeeded
        
        [[AppDelegate sharedDelegate] deleteLoginData];
        [[AppDelegate sharedDelegate] goToSplash];
    }
}

- (IBAction)onChangeEmail:(id)sender {
    [self.view endEditing:YES];
    changeEmailView.hidden = NO;
    
}

- (IBAction)onChangeEmailOfEmailView:(id)sender {
    [self.view endEditing:YES];
    FIRUser *user = [FIRAuth auth].currentUser;
    
    [user updateEmail:changeNewEmail.text completion:^(NSError *_Nullable error) {
        if (error) {
            // An error happened.
        } else {
            // Email updated.
            changeEmailView.hidden = YES;
        }
    }];
}

- (IBAction)onCancelOfEmailView:(id)sender {
    [self.view endEditing:YES];
    changeEmailView.hidden = YES;
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)onChnagePasswordOfPwdview:(id)sender {
    [self.view endEditing:YES];
    if (![changeNewPwdForPv.text isEqualToString:changeVerifyPwdForPV.text]) {
        [self showAlert:@"Passwords don't match!" :@"Oops!" :nil];
        return;
    }
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString *userEmail = user.email;
    
    [[FIRAuth auth] sendPasswordResetWithEmail:userEmail completion:^(NSError *_Nullable error){
        if (error) {
            NSLog(@"Failed : %@", error);
        }else{
            [self showAlert:@"App sent email successfully!" :@"Success" :nil];
        }
    }];
}

- (IBAction)onCancelOfPasswordView:(id)sender {
    [self.view endEditing:YES];
    changePasswordView.hidden = YES;
}

- (IBAction)onChangeGoal:(id)sender {
    [self.view endEditing:YES];
    GoalTableView.hidden = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Please select your Goal:";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayGoal count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *sortTableViewIdentifier = @"GoalItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sortTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sortTableViewIdentifier];
    }
    cell.textLabel.text =[arrayGoal objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [AppDelegate sharedDelegate].goal = [arrayGoal objectAtIndex:indexPath.row];
    [[AppDelegate sharedDelegate] saveLoginData];
    
    GoalTableView.hidden = YES;
    currentGoal.text = [arrayGoal objectAtIndex:indexPath.row];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [AppDelegate sharedDelegate].aboutMe = textField.text;
    [[AppDelegate sharedDelegate] saveLoginData];
    return YES;
}

-(void)handleTap
{
    [self.view endEditing:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    if([touch.view isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    // UITableViewCellContentView => UITableViewCell
    if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    // UITableViewCellContentView => UITableViewCellScrollView => UITableViewCell
    if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    return YES;
}
@end
