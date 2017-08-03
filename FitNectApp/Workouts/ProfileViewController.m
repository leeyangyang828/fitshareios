//
//  ProfileViewController.m
//  FitNectApp
//
//  Created by stepanekdavid on 8/23/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "ProfileViewController.h"
#import "PreviewWorkOutsViewController.h"
#import "SettingViewController.h"
#import "UIImageView+AFNetworking.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import "WorkoutsOfUsersCell.h"
@import Firebase;
@interface ProfileViewController ()<UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *arrFouseUserWorkouts;
    NSMutableArray *arrNamerForWorks;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrFouseUserWorkouts = [[NSMutableArray alloc] init];
    arrNamerForWorks = [[NSMutableArray alloc] init];
    _lblFouseUserName.text =_selectedUserNameForWorkouts;
    
    [self getFouseUserInfos];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(onBackClick:)forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(26, 3, 150, 20)];
    [label setFont:[UIFont fontWithName:@"Ariral-BoldMT" size:17]];
    [label setText:_selectedUserNameForWorkouts];
    label.textAlignment = UITextAlignmentCenter;
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [leftButton addSubview:label];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = barButton;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *barButton3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onPreviewMenu:)];
    self.navigationItem.rightBarButtonItem = barButton3;
    
    _selectedUserProfileImageview.contentMode = UIViewContentModeScaleAspectFill;
    _selectedUserProfileImageview.clipsToBounds = YES;
    _selectedUserProfileImageview.layer.cornerRadius = CGRectGetWidth(_selectedUserProfileImageview.frame) / 2;
}
- (void)getFouseUserInfos{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
    
    [[rootR queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSDictionary *dict = snapshot.value;
       // if ([snapshot.key isEqualToString:@"user info"]) {
            for (NSString *snap in [dict objectForKey:@"user info"]) {
                
                NSDictionary *dictOne = [[dict objectForKey:@"user info"] objectForKey:snap];
                NSString *username = [snap stringByReplacingOccurrencesOfString:@" " withString:@""];
                if ([[[dictOne objectForKey:@"username"] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[_selectedUserNameForWorkouts stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
                    [_selectedUserProfileImageview setImageWithURL:[NSURL URLWithString:[dictOne objectForKey:@"profileUrl"]]];
                    lblAboutMeAndGoal.text = [NSString stringWithFormat:@"%@\n%@", [dictOne objectForKey:@"aboutMe"], [dictOne objectForKey:@"goal"]];
                }
                if ([[_selectedUserNameForWorkouts stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:username]) {
                    if ([dictOne objectForKey:@"completeNumber"]) {
                        _numCompletedFouseUser.text = [NSString stringWithFormat:@"%@ Workouts completed", [dictOne objectForKey:@"completeNumber"]];
                    }else{
                        _numCompletedFouseUser.text = @"0 Workouts completed";
                    }
                    if ([dictOne objectForKey:@"sharedNumber"]) {
                        _numSharedFouseUser.text = [NSString stringWithFormat:@"%@ Workouts shared", [dictOne objectForKey:@"sharedNumber"]];
                    }else{
                        _numSharedFouseUser.text = @"0 Workouts shared";
                    }
                }
            }
       // }
        [arrFouseUserWorkouts removeAllObjects];
        [arrNamerForWorks removeAllObjects];
        for (NSDictionary *dict in [AppDelegate sharedDelegate].availWorkouts) {
            
            NSString *username = [dict objectForKey:@"username"];
            
            if ([_selectedUserNameForWorkouts isEqualToString:username]) {
                
                [arrFouseUserWorkouts addObject:dict];
                [arrNamerForWorks addObject:[dict objectForKey:@"workout"]];
            }
        }
        [_fouseUserWorksTableview reloadData];
    }
    withCancelBlock:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@", error.description);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onPreviewMenu:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Setting", @"Logout", nil];
    [actionSheet showInView:self.view];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrNamerForWorks count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"WorkOutsTableCell";
    WorkoutsOfUsersCell *cell = [_fouseUserWorksTableview dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [WorkoutsOfUsersCell sharedCell];
    }
    
    [cell setDelegate:self];
    NSDictionary *oneWorkout = [arrFouseUserWorkouts objectAtIndex:indexPath.row];
    
    [cell setCurWorkoutsItem:oneWorkout];
    cell.workoutsName.text =[oneWorkout objectForKey:@"workout"];
    cell.matchedUsername.text = @"";
    cell.likesForworkouts.text = @"";
    if ([oneWorkout objectForKey:@"workoutImageUrl"]) {
        [cell.workoutImg setImageWithURL:[NSURL URLWithString:[oneWorkout objectForKey:@"workoutImageUrl"]]];
        NSLog(@"%@", [oneWorkout objectForKey:@"workoutImageUrl"]);
    }else{
        [cell.workoutImg setImage:[UIImage imageNamed:@"workout_logo.png"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dict = [arrFouseUserWorkouts objectAtIndex:indexPath.row];
    PreviewWorkOutsViewController *previewWorkOutsViewController = [[PreviewWorkOutsViewController alloc] initWithNibName:nil bundle:nil];
    previewWorkOutsViewController.infoSelectedWorkOuts =dict;
    [self.navigationController pushViewController:previewWorkOutsViewController animated:YES];
    
}
- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
