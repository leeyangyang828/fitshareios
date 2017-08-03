//
//  WorkOutHomeViewController.m
//  FitNectApp
//
//  Created by stepanekdavid on 12/12/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "WorkOutHomeViewController.h"
#import "NotificationViewController.h"
#import "SettingViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "WorkOutHomeViewController.h"
#import "AddEditWorkOutsViewController.h"
#import "MyWorkOutViewController.h"
#import "MyWorkoutsListViewController.h"
@import Firebase;
@import FirebaseStorage;

@interface WorkOutHomeViewController ()<UIActionSheetDelegate>

@end

@implementation WorkOutHomeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height + 450.0f)];
    if ([AppDelegate sharedDelegate].isShownWelcome) {
        welcomeView.hidden = YES;
    }else{
        welcomeView.hidden = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IS_IPHONE_5) {
        [_navView setFrame:CGRectMake(0, 0, 320, 44)];
    }else{
        
        [_navView setFrame:CGRectMake(0, 0, self.view.superview.frame.size.width, 44)];
    }
    [self.navigationController.navigationBar addSubview:_navView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onMyWorkouts:(id)sender {
    
    MyWorkoutsListViewController *vc = [[MyWorkoutsListViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onStrengthTraing:(id)sender {
    MyWorkOutViewController *addEditWorkOutsViewController = [[MyWorkOutViewController alloc] initWithNibName:nil bundle:nil];
    //[self presentViewController:loginViewController animated:YES completion:NULL];
    [AppDelegate sharedDelegate].workoutSelectedType = 1;
    addEditWorkOutsViewController.type = 1;
    [self.navigationController pushViewController:addEditWorkOutsViewController animated:YES];
}

- (IBAction)onCardioTraining:(id)sender {
    MyWorkOutViewController *addEditWorkOutsViewController = [[MyWorkOutViewController alloc] initWithNibName:nil bundle:nil];
    //[self presentViewController:loginViewController animated:YES completion:NULL];
    addEditWorkOutsViewController.type = 2;
    [AppDelegate sharedDelegate].workoutSelectedType = 2;
    [self.navigationController pushViewController:addEditWorkOutsViewController animated:YES];
}

- (IBAction)onTrainerWorkouts:(id)sender {
    MyWorkOutViewController *addEditWorkOutsViewController = [[MyWorkOutViewController alloc] initWithNibName:nil bundle:nil];
    //[self presentViewController:loginViewController animated:YES completion:NULL];
    addEditWorkOutsViewController.type = 3;
    [AppDelegate sharedDelegate].workoutSelectedType = 3;
    [self.navigationController pushViewController:addEditWorkOutsViewController animated:YES];
}

- (IBAction)onFitShareFeatured:(id)sender {
    MyWorkOutViewController *addEditWorkOutsViewController = [[MyWorkOutViewController alloc] initWithNibName:nil bundle:nil];
    //[self presentViewController:loginViewController animated:YES completion:NULL];
    addEditWorkOutsViewController.type = 4;
    [AppDelegate sharedDelegate].workoutSelectedType = 4;
    [self.navigationController pushViewController:addEditWorkOutsViewController animated:YES];
}

- (IBAction)onNotification:(id)sender {
    NotificationViewController *vc = [[NotificationViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onMenu:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Setting", @"Logout", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)onStart:(id)sender {
    welcomeView.hidden = YES;
}

- (IBAction)onCheckShown:(id)sender {
    shownCheckBtn.selected = !shownCheckBtn.selected;
    if (shownCheckBtn.selected) {
        [AppDelegate sharedDelegate].isShownWelcome = YES;
    }else{
        [AppDelegate sharedDelegate].isShownWelcome = NO;
    }
    [[AppDelegate sharedDelegate] saveLoginData];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 2) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }
        switch (buttonIndex) {
            case 0:
            {
                SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
                [self presentViewController:viewController animated:YES completion:nil];
            }
                break;
            case 1:{
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
                break;
            default:
                break;
        }
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
@end
