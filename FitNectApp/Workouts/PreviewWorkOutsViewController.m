//
//  PreviewWorkOutsViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/26/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import "PreviewWorkOutsViewController.h"
#import "WorkOutsCell.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "UserWorkoutsViewController.h"
#import "MBProgressHUD.h"

#import "ProfileViewController.h"
#import "BeginWorkoutsViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "RepsCell.h"

#import "UIImageView+AFNetworking.h"
@import Firebase;
@interface PreviewWorkOutsViewController ()<WorkOutsCellDelegate>{
    NSMutableArray *arrALLExercies;
    BOOL isSelectedFitLove;
    BOOL isUpdated;
    NSArray *arrayForST;
    
}

@end

@implementation PreviewWorkOutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    arrALLExercies = [[NSMutableArray alloc] init];
    
    noteView.hidden = YES;
    isSelectedFitLove = NO;
    isUpdated = NO;
    
    
    NSInteger index = 0;
    NSMutableArray *availReps = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[_infoSelectedWorkOuts objectForKey:@"sets"] count]; i ++) {
        NSMutableArray *lineReps = [[NSMutableArray alloc] init];
        NSString *oneSets = [[_infoSelectedWorkOuts objectForKey:@"sets"] objectAtIndex:i];
        [lineReps addObject:oneSets];
        NSArray *parseSets = [oneSets componentsSeparatedByString:@" "];
        if ([parseSets[[parseSets count]-1] isEqualToString:@"Sets"]) {
            for (int j = 0; j < [parseSets[0] integerValue]; j ++) {
                if ([[_infoSelectedWorkOuts objectForKey:@"reps"] objectAtIndex:index+j])
                    [lineReps addObject:[[_infoSelectedWorkOuts objectForKey:@"reps"] objectAtIndex:index+j]];
            }
        }
        index = index + [parseSets[0] integerValue];
        NSArray *arryLineRes = [lineReps copy];
        [availReps addObject:arryLineRes];
    }
    arrayForST = [availReps copy];
    workoutsFromFireBaseTableview.SKSTableViewDelegate = self;
    
    lblWorkoutsName.text = [_infoSelectedWorkOuts objectForKey:@"workout"];
    [selectedWorkUsernamer setTitle:[_infoSelectedWorkOuts objectForKey:@"username"] forState:UIControlStateNormal];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(onBackClick:)forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(26, 3, 70, 20)];
    [label setFont:[UIFont fontWithName:@"Ariral-BoldMT" size:17]];
    [label setText:@"FitShare"];
    label.textAlignment = UITextAlignmentCenter;
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [leftButton addSubview:label];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = barButton;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"begin_wo"] style:UIBarButtonItemStylePlain target:self action:@selector(onBeginWoClick:)];
    barButton2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fitlove-1"] style:UIBarButtonItemStylePlain target:self action:@selector(onNoteClick:)];
    UIBarButtonItem *barButton3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onPreviewMenu:)];
    self.navigationItem.rightBarButtonItems = @[barButton3, barButton2, barButton1];
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    NSFetchRequest *allContacts = [[NSFetchRequest alloc] init];
    [allContacts setEntity:[NSEntityDescription entityForName:@"Fitlove" inManagedObjectContext:context]];
    NSError *error = nil;
    NSArray *fitLoves = [context executeFetchRequest:allContacts error:&error];
    NSArray *foundContacts = [fitLoves filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"username == %@ AND workoutsName == %@", [AppDelegate sharedDelegate].userName,[_infoSelectedWorkOuts objectForKey:@"key"]]];
    if (foundContacts.count > 0) {
        Fitlove *exitedFitLove = foundContacts[0];
        isSelectedFitLove = [exitedFitLove.isFitLove boolValue];
    }
    if (isSelectedFitLove) {
        [barButton2 setImage:[UIImage imageNamed:@"fitlove_orange"]];
        [barButton2 setTintColor:[UIColor colorWithRed:255.0f/255.0f green:145.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    }
    profileImage.contentMode = UIViewContentModeScaleAspectFill;
    profileImage.clipsToBounds = YES;
    profileImage.layer.cornerRadius = CGRectGetWidth(profileImage.frame) / 2;
    [self getFouseUserInfos];
    lblLoveCounts.text = [NSString stringWithFormat:@"Likes %@", [_infoSelectedWorkOuts objectForKey:@"likes"]];
    if ([AppDelegate sharedDelegate].isShownTipViewForWorkout) {
        tipViewWorkouts.hidden = YES;
    }else{
        tipViewWorkouts.hidden = NO;
    }

}
- (void)getFouseUserInfos{
    NSString * selectedUserName =[_infoSelectedWorkOuts objectForKey:@"username"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
    
    [[rootR queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSDictionary *dict = snapshot.value;
        // if ([snapshot.key isEqualToString:@"user info"]) {
        for (NSString *snap in [dict objectForKey:@"user info"]) {
            
            NSDictionary *dictOne = [[dict objectForKey:@"user info"] objectForKey:snap];
            if ([[[dictOne objectForKey:@"username"] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[selectedUserName stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
                if ([dictOne objectForKey:@"profileUrl"]) {
                    [profileImage setImageWithURL:[NSURL URLWithString:[dictOne objectForKey:@"profileUrl"]]];
                }
            }
        }
    }
    withCancelBlock:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@", error.description);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.navigationController.navigationBar addSubview:navView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[navView removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayForST count];
}
- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:workoutsFromFireBaseTableview]) {
        return [arrayForST[indexPath.row] count] - 1;
    }
    return 0;
}
- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return YES;
    }
    
    return NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"WorkoutCell";
    WorkOutsCell *cell = [workoutsFromFireBaseTableview dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [WorkOutsCell sharedCell];
    }
    
    cell.resDelegate = self;
    if ([arrayForST[indexPath.row] count] > 0)
        cell.expandable = YES;
    else
        cell.expandable = NO;
    [cell setCurWorkoutsItem:[[_infoSelectedWorkOuts objectForKey:@"comment"] objectAtIndex:indexPath.row]];
    
    [cell.txtExercise setText:[[_infoSelectedWorkOuts objectForKey:@"exercise"] objectAtIndex:indexPath.row]];
    [cell.txtSets setText:[[_infoSelectedWorkOuts objectForKey:@"sets"] objectAtIndex:indexPath.row]];
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RepsItem";
    RepsCell *cell = (RepsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSString *dict = [arrayForST objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [RepsCell sharedCell];
    }
    [cell setCurWorkoutsItem:[NSString stringWithFormat:@"%@", arrayForST[indexPath.row][indexPath.subRow]]];
    cell.lblNameRep.text = [NSString stringWithFormat:@"Set %ld", (long)indexPath.subRow];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
    
}
- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
}
- (IBAction)onBeginWoClick:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Begin workout" message:@"Are you ready to begin this workout?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag = 300;
    [alert show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        if (alertView.tag == 300) {
            BeginWorkoutsViewController *viewController = [[BeginWorkoutsViewController alloc] initWithNibName:nil bundle:nil];
            viewController.beginingArray =_infoSelectedWorkOuts;
            [self.navigationController pushViewController:viewController animated:YES];
            return;
        }
    }
}
- (IBAction)onFaveriteClick:(id)sender {
    if ([[AppDelegate sharedDelegate].userName isEqualToString:[_infoSelectedWorkOuts objectForKey:@"username"]]) {
        return;
    }
    
    isSelectedFitLove = NO;
    
    
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
//        Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://fitnect.firebaseio.com"];
//        [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            
//            NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
//            
//            NSFetchRequest *allContacts = [[NSFetchRequest alloc] init];
//            [allContacts setEntity:[NSEntityDescription entityForName:@"Fitlove" inManagedObjectContext:context]];
//            NSError *error = nil;
//            NSArray *fitLoves = [context executeFetchRequest:allContacts error:&error];
//            NSArray *foundContacts = [fitLoves filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"username == %@ AND workoutsName == %@", [AppDelegate sharedDelegate].userName,[_infoSelectedWorkOuts objectForKey:@"workoutsId"]]];
//            if (foundContacts.count > 0) {
//                Fitlove *exitedFitLove = foundContacts[0];
//                isSelectedFitLove = [exitedFitLove.isFitLove boolValue];
//            }else{
//                Fitlove *fitlove = [NSEntityDescription insertNewObjectForEntityForName:@"Fitlove" inManagedObjectContext:context];
//                fitlove.username = [AppDelegate sharedDelegate].userName;
//                fitlove.workoutsName = [_infoSelectedWorkOuts objectForKey:@"workoutsId"];
//                fitlove.isFitLove = @0;
//                NSError *saveError = nil;
//                [context save:&saveError];
//                if (saveError) {
//                    NSLog(@"Error when saving managed object context : %@", saveError);
//                }
//                isSelectedFitLove = NO;
//            }
//            if (!isUpdated && !isSelectedFitLove) {
//                
//                Firebase *addUser = [myRootRef childByAppendingPath:@"Workouts"];
//                Firebase *postRef = [addUser childByAppendingPath:[_infoSelectedWorkOuts objectForKey:@"workoutsId"]];
//                NSString *likes = [[_infoSelectedWorkOuts objectForKey:@"data"] objectForKey:@"likes"];
//                int likesInt = [likes intValue];
//                likesInt++;
//                NSNumber *likesCount = [NSNumber numberWithInt:likesInt];
//                NSMutableDictionary *updateLikes = [[NSMutableDictionary alloc] init];
//                [updateLikes setObject:likesCount forKey:@"likes"];
//                [postRef updateChildValues:@{@"likes":likesCount}];
//                isUpdated = YES;
//            }else{
//                NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
//                
//                NSFetchRequest *allContacts = [[NSFetchRequest alloc] init];
//                [allContacts setEntity:[NSEntityDescription entityForName:@"Fitlove" inManagedObjectContext:context]];
//                NSError *error = nil;
//                NSArray *fitLoves = [context executeFetchRequest:allContacts error:&error];
//                NSArray *foundContacts = [fitLoves filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"username == %@ AND workoutsName == %@", [AppDelegate sharedDelegate].userName,[_infoSelectedWorkOuts objectForKey:@"workoutsId"]]];
//                if (foundContacts.count > 0) {
//                    Fitlove *exitedFitLove = foundContacts[0];
//                    exitedFitLove.isFitLove = @1;
//                }
//                NSError *saveError = nil;
//                [context save:&saveError];
//                if (saveError) {
//                    NSLog(@"Error when saving managed object context : %@", saveError);
//                }
//                isSelectedFitLove = YES;
//            }
//            
//        } withCancelBlock:^(NSError *error){
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            NSLog(@"%@", error.description);
//        }];
   
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNoteClick:(id)sender {
    [barButton2 setImage:[UIImage imageNamed:@"fitlove_orange"]];
    [barButton2 setTintColor:[UIColor colorWithRed:255.0f/255.0f green:145.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FIRDatabaseReference *myRootRef = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
    
    [[myRootRef queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
        
        NSFetchRequest *allContacts = [[NSFetchRequest alloc] init];
        [allContacts setEntity:[NSEntityDescription entityForName:@"Fitlove" inManagedObjectContext:context]];
        NSError *error = nil;
        NSArray *fitLoves = [context executeFetchRequest:allContacts error:&error];
        NSArray *foundContacts = [fitLoves filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"username == %@ AND workoutsName == %@", [AppDelegate sharedDelegate].userName,[_infoSelectedWorkOuts objectForKey:@"key"]]];
        if (foundContacts.count > 0) {
            Fitlove *exitedFitLove = foundContacts[0];
            isSelectedFitLove = [exitedFitLove.isFitLove boolValue];
        }else{
            Fitlove *fitlove = [NSEntityDescription insertNewObjectForEntityForName:@"Fitlove" inManagedObjectContext:context];
            fitlove.username = [AppDelegate sharedDelegate].userName;
            fitlove.workoutsName = [_infoSelectedWorkOuts objectForKey:@"key"];
            fitlove.isFitLove = @0;
            NSError *saveError = nil;
            [context save:&saveError];
            if (saveError) {
                NSLog(@"Error when saving managed object context : %@", saveError);
            }
            isSelectedFitLove = NO;
        }
        if (!isUpdated && !isSelectedFitLove) {
            FIRDatabaseReference *addUser;
            switch ([AppDelegate sharedDelegate].workoutSelectedType) {
                case 1:
                    addUser = [myRootRef child:@"Strength Training"];
                    break;
                case 2:
                    addUser = [myRootRef child:@"Cardio Training"];
                    break;
                case 3:
                    addUser = [myRootRef child:@"Trainer Workout"];
                    break;
                case 4:
                    addUser = [myRootRef child:@"Workouts"];
                    break;
                default:
                    break;
            }
            FIRDatabaseReference *postRef = [addUser child:[_infoSelectedWorkOuts objectForKey:@"key"]];
            NSString *likes = [_infoSelectedWorkOuts objectForKey:@"likes"];
            int likesInt = [likes intValue];
            likesInt++;
            NSNumber *likesCount = [NSNumber numberWithInt:likesInt];
            NSMutableDictionary *updateLikes = [[NSMutableDictionary alloc] init];
            [updateLikes setObject:likesCount forKey:@"likes"];
            [postRef updateChildValues:@{@"likes":likesCount}];
            isUpdated = YES;
            lblLoveCounts.text =[NSString stringWithFormat:@"Likes %d",likesInt];
            
            FIRDatabaseReference *notificationRef = [[myRootRef child:@"notification"] childByAutoId];
            NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
            [userInfoForPost setValue:@(0) forKey:@"completeNumber"];
            [userInfoForPost setValue:[_infoSelectedWorkOuts objectForKey:@"username"] forKey:@"notifReceiver"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].userName forKey:@"notifSender"];
            [userInfoForPost setValue:[_infoSelectedWorkOuts objectForKey:@"workout"] forKey:@"notifWorkout"];
            [userInfoForPost setValue:@(0) forKey:@"sharedNumber"];
            
            [notificationRef setValue:userInfoForPost];
        }else{
            NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
            
            NSFetchRequest *allContacts = [[NSFetchRequest alloc] init];
            [allContacts setEntity:[NSEntityDescription entityForName:@"Fitlove" inManagedObjectContext:context]];
            NSError *error = nil;
            NSArray *fitLoves = [context executeFetchRequest:allContacts error:&error];
            NSArray *foundContacts = [fitLoves filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"username == %@ AND workoutsName == %@", [AppDelegate sharedDelegate].userName,[_infoSelectedWorkOuts objectForKey:@"key"]]];
            if (foundContacts.count > 0) {
                Fitlove *exitedFitLove = foundContacts[0];
                exitedFitLove.isFitLove = @1;
            }
            NSError *saveError = nil;
            [context save:&saveError];
            if (saveError) {
                NSLog(@"Error when saving managed object context : %@", saveError);
            }
            isSelectedFitLove = YES;
        }
        
    } withCancelBlock:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@", error.description);
    }];
}
- (IBAction)onCloseClick:(id)sender {
    noteView.hidden = YES;
}

- (IBAction)onPreviewMenu:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save", @"Setting", @"Logout", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)onSelectedWorkUserName:(id)sender {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
    profileViewController.selectedUserNameForWorkouts =[_infoSelectedWorkOuts objectForKey:@"username"];
    [self.navigationController pushViewController:profileViewController animated:YES];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 3) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }
    switch (buttonIndex) {
        case 0:{
            NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
            
            NSFetchRequest *allContacts = [[NSFetchRequest alloc] init];
            [allContacts setEntity:[NSEntityDescription entityForName:@"Workouts" inManagedObjectContext:context]];
            
            Workouts *workouts = [NSEntityDescription insertNewObjectForEntityForName:@"Workouts" inManagedObjectContext:context];
            workouts.userId = [AppDelegate sharedDelegate].sessionId;
            workouts.title = [_infoSelectedWorkOuts objectForKey:@"workout"];
            workouts.typeWorkouts = @0;
            workouts.data = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:_infoSelectedWorkOuts options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            
            NSError *saveError = nil;
            [context save:&saveError];
            if (saveError) {
                NSLog(@"Error when saving managed object context : %@", saveError);
            }
        }
            break;
        case 1:
        {
            SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
            [self presentViewController:viewController animated:YES completion:nil];
        }
            break;
        case 2:{
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
- (void)didComments:(NSString *)workoutsDict{
    noteView.hidden = NO;
    lblComments.text = workoutsDict;
}
- (IBAction)onTipViewClose:(id)sender {
    tipViewWorkouts.hidden = YES;
}

- (IBAction)onCheckTipViewBtn:(id)sender {
    tipViewCheckBtn.selected = !tipViewCheckBtn.selected;
    if (tipViewCheckBtn.selected) {
        [AppDelegate sharedDelegate].isShownTipViewForWorkout = YES;
    }else{
        [AppDelegate sharedDelegate].isShownTipViewForWorkout = NO;
    }
    [[AppDelegate sharedDelegate] saveLoginData];
}
@end
