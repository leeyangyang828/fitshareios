//
//  MyWorkOutViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/25/15.
//  Copyright © 2015 jella. All rights reserved.
//

#import "MyWorkOutViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "AddEditWorkOutsViewController.h"
#import "MBProgressHUD.h"
#import "WorkOutsViewController.h"
#import "SettingViewController.h"
#import "WorkoutsOfUsersCell.h"
#import "PreviewWorkOutsViewController.h"
#import "UIImageView+AFNetworking.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
@import Firebase;
@interface MyWorkOutViewController (){
    NSMutableArray *arrayWorkouts;
    NSMutableArray * searchedWorkouts;
    NSMutableArray *typeArrworkouts;
    BOOL isEmpty;
    BOOL isSeleted;
    int type;
}

@end

@implementation MyWorkOutViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayWorkouts = [[NSMutableArray alloc] init];
    typeArrworkouts = [[NSMutableArray alloc] init];
    isEmpty= NO;
    isSeleted = NO;
    type = 1;
    
    currentProfileImageview.contentMode = UIViewContentModeScaleAspectFill;
    currentProfileImageview.clipsToBounds = YES;
    currentProfileImageview.layer.cornerRadius = CGRectGetWidth(currentProfileImageview.frame) / 2;
    
    if (![[AppDelegate sharedDelegate].curUserProfileImageUrl isEqualToString:@""]) {
        
        //            [[[FIRStorage storage] referenceForURL:[AppDelegate sharedDelegate].curUserProfileImageUrl] dataWithMaxSize:INT64_MAX completion:^(NSData *data, NSError *error) {
        //                if (error) {
        //                    NSLog(@"Error downloading: %@", error);
        //                    return;
        //                }
        //                [currentUserProfileImge setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        //            }];
        NSLog(@"%@", [AppDelegate sharedDelegate].curUserProfileImageUrl);
        [currentProfileImageview setImageWithURL:[NSURL URLWithString:[AppDelegate sharedDelegate].curUserProfileImageUrl]];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IS_IPHONE_5) {
        [navView setFrame:CGRectMake(0, 0, 320, 44)];
    }else{
        
        [navView setFrame:CGRectMake(0, 0, self.view.superview.frame.size.width, 44)];
    }
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar addSubview:navView];
    [self getFilteredWorkouts];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getFilteredWorkouts{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FIRDatabaseReference *rootR;
    switch (_type) {
        case 1:
            rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/Strength Training"];
            break;
        case 2:
            rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/Cardio Training"];
            break;
        case 3:
            rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/Trainer Workout"];
            break;
        case 4:
            rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/Workouts"];
            break;
        default:
            break;
    }
    
    [[rootR queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *responseObject;
        if (![snapshot.value isKindOfClass:[NSNull class]]) {
            NSLog(@"%@", snapshot.value);
            switch (_type) {
                case 1:
                    if (![snapshot.value[@"Strength Training"] isKindOfClass:[NSNull class]]) {
                        responseObject = snapshot.value[@"Strength Training"];
                    }
                    break;
                case 2:
                    if (![snapshot.value[@"Cardio Training"] isKindOfClass:[NSNull class]]) {
                        responseObject = snapshot.value[@"Cardio Training"];
                    }
                    break;
                case 3:
                    if (![snapshot.value[@"Trainer Training"] isKindOfClass:[NSNull class]]) {
                        responseObject = snapshot.value[@"Trainer Workout"];
                    }
                    break;
                case 4:
                    if (![snapshot.value[@"Workouts"] isKindOfClass:[NSNull class]]) {
                        responseObject = snapshot.value[@"Workouts"];
                    }
                    break;
                default:
                    break;
            }
            NSLog(@"key - %@", snapshot.key);
            
            
            if ([snapshot.key isEqualToString:@"Workouts"] || [snapshot.key isEqualToString:@"Strength Training"] || [snapshot.key isEqualToString:@"Cardio Training"] || [snapshot.key isEqualToString:@"Trainer Workout"]) {
                [[AppDelegate sharedDelegate].availWorkouts removeAllObjects];
                for (FIRDataSnapshot *one in snapshot.children) {
                    NSString *strComment =[[one.value[@"comment"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    NSString *strExercise =[[one.value[@"exercise"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    NSString *strLikes =one.value[@"likes"];
                    NSString *strReps =[[one.value[@"reps"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    NSString *strSets =[[one.value[@"sets"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    NSString *strUsername =one.value[@"username"];
                    NSString *strWorkouts =one.value[@"workout"];
                    
                    NSArray *arrComments = [strComment componentsSeparatedByString:@", "];
                    NSArray *arrExercises = [strExercise componentsSeparatedByString:@", "];
                    NSArray *arrReps = [[strReps stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@","];
                    NSArray *arrSets = [strSets componentsSeparatedByString:@", "];
                    
                    NSMutableDictionary *oneWorkouts = [[NSMutableDictionary alloc] init];
                    [oneWorkouts setObject:arrComments forKey:@"comment"];
                    [oneWorkouts setObject:arrExercises forKey:@"exercise"];
                    [oneWorkouts setObject:arrReps forKey:@"reps"];
                    [oneWorkouts setObject:arrSets forKey:@"sets"];
                    [oneWorkouts setObject:strUsername forKey:@"username"];
                    [oneWorkouts setObject:strWorkouts forKey:@"workout"];
                    [oneWorkouts setObject:strLikes forKey:@"likes"];
                    [oneWorkouts setObject:one.key forKey:@"key"];
                    if (one.value[@"goal"]) {
                        [oneWorkouts setObject:one.value[@"goal"] forKey:@"goal"];
                    }
                    if (one.value[@"image"]) {
                        if ([one.value[@"image"] rangeOfString:@"http"].location !=NSNotFound) {
                            [oneWorkouts setObject:one.value[@"image"] forKey:@"workoutImageUrl"];
                        }
                    }
                    [[AppDelegate sharedDelegate].availWorkouts addObject:oneWorkouts];
                }
            }
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workout" ascending:YES selector:@selector(localizedStandardCompare:)];
            NSMutableArray * sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
            [[AppDelegate sharedDelegate].availWorkouts sortUsingDescriptors:sortDescriptors];
            
            searchedWorkouts = [[NSMutableArray alloc] init];
            [arrayWorkouts removeAllObjects];
            [typeArrworkouts removeAllObjects];
            arrayWorkouts = [[AppDelegate sharedDelegate].availWorkouts mutableCopy];
            searchedWorkouts =[[AppDelegate sharedDelegate].availWorkouts mutableCopy];
            typeArrworkouts = [[AppDelegate sharedDelegate].availWorkouts mutableCopy];
            [WorkoutsFromDBTableView reloadData];
        }
        
    }
    withCancelBlock:^(NSError *error){
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"%@", error.description);
    }];
}
- (NSArray *)parseStringToArray:(NSString *)string{
    NSArray *array = [string componentsSeparatedByString:@", "];;
    return array;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [searchedWorkouts count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"WorkOutsTableCell";
    WorkoutsOfUsersCell *cell = [WorkoutsFromDBTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [WorkoutsOfUsersCell sharedCell];
    }
    
    [cell setDelegate:self];
    NSDictionary *oneWorkout = [searchedWorkouts objectAtIndex:indexPath.row];
    
    [cell setCurWorkoutsItem:oneWorkout];
    cell.workoutsName.text =[oneWorkout objectForKey:@"workout"];
    cell.matchedUsername.text = [oneWorkout objectForKey:@"username"];
    cell.likesForworkouts.text = [NSString stringWithFormat:@"%@", [oneWorkout objectForKey:@"likes"] ];
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
    NSMutableDictionary *dict = [searchedWorkouts objectAtIndex:indexPath.row];
    PreviewWorkOutsViewController *previewWorkOutsViewController = [[PreviewWorkOutsViewController alloc] initWithNibName:nil bundle:nil];
    previewWorkOutsViewController.infoSelectedWorkOuts =dict;
    [self.navigationController pushViewController:previewWorkOutsViewController animated:YES];
}

#pragma - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    [searchedWorkouts removeAllObjects];
    
    searchedWorkouts =[typeArrworkouts mutableCopy];
    [WorkoutsFromDBTableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [workoutsSearchBar resignFirstResponder];
    if (searchBar.text.length != 0) {
        searchedWorkouts = [NSMutableArray new];
        for (NSDictionary *workouts in typeArrworkouts) {
            NSString *name = @"";
            name = [workouts objectForKey:@"workout"];
            if ([[name lowercaseString] rangeOfString:searchBar.text.lowercaseString].location != NSNotFound) {
                [searchedWorkouts addObject:workouts];
            }
        }
    } else {
        [searchedWorkouts removeAllObjects];
        
        searchedWorkouts =[typeArrworkouts mutableCopy];
    }
    
    [WorkoutsFromDBTableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length != 0) {
        searchedWorkouts = [NSMutableArray new];
        for (NSDictionary *workouts in typeArrworkouts) {
            NSString *name = @"";
            name = [workouts objectForKey:@"workout"];
            if ([[name lowercaseString] rangeOfString:searchText.lowercaseString].location != NSNotFound) {
                [searchedWorkouts addObject:workouts];
            }
        }
    } else {
        [searchedWorkouts removeAllObjects];
        searchedWorkouts =[typeArrworkouts mutableCopy];
    }
    
    [WorkoutsFromDBTableView reloadData];
}


- (IBAction)onAddWorkous:(id)sender {
    AddEditWorkOutsViewController *addEditWorkOutsViewController = [[AddEditWorkOutsViewController alloc] initWithNibName:nil bundle:nil];
    //[self presentViewController:loginViewController animated:YES completion:NULL];
    [self.navigationController pushViewController:addEditWorkOutsViewController animated:YES];
}

- (IBAction)onFindNew:(id)sender {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://fitnect.firebaseio.com"];
//    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        NSDictionary *responseObject = snapshot.value[@"Workouts"];
//        NSMutableArray *getWorkouts = [[NSMutableArray alloc] init];
//        for (NSString *workoutsId in responseObject) {
//        
//            NSMutableDictionary *muDict = [[NSMutableDictionary alloc] init];
//            [muDict setObject:workoutsId forKey:@"workoutsId"];
//            [muDict setObject:[responseObject objectForKey:workoutsId] forKey:@"data"];
//            [getWorkouts addObject:muDict];
//        }
//        
//        WorkOutsViewController *workOutsViewController = [[WorkOutsViewController alloc] initWithNibName:nil bundle:nil];
//        workOutsViewController.arrWorkoutsFromFireBase =getWorkouts;
//        [self.navigationController pushViewController:workOutsViewController animated:YES];
//        
//        
//    } withCancelBlock:^(NSError *error){
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        NSLog(@"%@", error.description);
//    }];
}

- (IBAction)onMyWorkoutMenu:(id)sender {
    isSeleted = NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Setting", @"Logout", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)onFileteredWorkouts:(id)sender {
    isSeleted = YES;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Workouts",@"Popular", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 2 && !isSeleted) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }
    if (buttonIndex == 2 && isSeleted) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }
    switch (buttonIndex) {
        case 0:
        {
            if (isSeleted) {
                type = 1;
                [btnFilterType setTitle:@"New Workouts" forState:UIControlStateNormal];
                [self filteredWorksouts:type];
            }else{
                SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
                [self presentViewController:viewController animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {
            if (isSeleted) {
                type = 2;
                [btnFilterType setTitle:@"Popular" forState:UIControlStateNormal];
                [self filteredWorksouts:type];
            }else{
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
        }
            break;
//        case 2:{
//            if (isSeleted) {
//                type = 3;
//                [btnFilterType setTitle:@"Popular" forState:UIControlStateNormal];
//                [self filteredWorksouts:type];
//            }
//        }
//            break;
//        case 3:{
//            if (isSeleted) {
//                type = 4;
//                [btnFilterType setTitle:@"My Goal" forState:UIControlStateNormal];
//                [self filteredWorksouts:type];
//            }
//        }
//            break;
//        case 4:{
//            if (isSeleted) {
//                type = 5;
//                [btnFilterType setTitle:@"My Gym" forState:UIControlStateNormal];
//                [self filteredWorksouts:type];
//            }
//        }
//            break;
        default:
            break;
    }

    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}
- (void)filteredWorksouts:(int)filteredType{
    switch (filteredType) {
        case 1:{
            [searchedWorkouts removeAllObjects];
            searchedWorkouts =[arrayWorkouts mutableCopy];
        }
            break;
//        case 5:{
//            [searchedWorkouts removeAllObjects];
//            for (NSDictionary *workouts in arrayWorkouts) {
//                
//                NSString *arrWorksName = [workouts objectForKey:@"username"];
//                
//                if ([[[AppDelegate sharedDelegate].userName stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[arrWorksName stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
//                    [searchedWorkouts addObject:workouts];
//                }
//            }
//            [typeArrworkouts removeAllObjects];
//            typeArrworkouts = [searchedWorkouts mutableCopy];
//        }
//            break;
        case 2:{
            [searchedWorkouts removeAllObjects];
            searchedWorkouts =[arrayWorkouts mutableCopy];
            
            NSMutableArray * sortedMtArray = [NSMutableArray new];
            sortedMtArray = searchedWorkouts;
            NSArray *orderedUsers = [sortedMtArray sortedArrayUsingComparator:^(id a,id b) {
                NSArray *userA = (NSArray *)a;
                NSArray *userB = (NSArray *)b;
                NSInteger likeA = [[userA valueForKey:@"likes"] integerValue];
                NSInteger likeB = [[userB valueForKey:@"likes"] integerValue];
                    if (likeA > likeB) {
                        return NSOrderedAscending;
                    } else if (likeA < likeB) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
            }];
            [searchedWorkouts removeAllObjects];
            //update EntityData by Sorted Data
            for (int i = 0; i < orderedUsers.count; i ++) {
                [searchedWorkouts addObject:orderedUsers[i]];
            }
            
            
            [typeArrworkouts removeAllObjects];
            typeArrworkouts = [searchedWorkouts mutableCopy];
        }
            break;
//        case 4:{
//            [searchedWorkouts removeAllObjects];
//            for (NSDictionary *workouts in arrayWorkouts) {
//                
//                NSString *arrWorksGoal = [workouts objectForKey:@"goal"];
//                
//                if ([[AppDelegate sharedDelegate].goal isEqualToString:arrWorksGoal]) {
//                    [searchedWorkouts addObject:workouts];
//                }
//            }
//            [typeArrworkouts removeAllObjects];
//            typeArrworkouts = [searchedWorkouts mutableCopy];
//        }
//            break;
//        case 2:{
//            [searchedWorkouts removeAllObjects];
//            for (NSDictionary *workouts in arrayWorkouts) {
//                
//                NSString *arrWorksName = [workouts objectForKey:@"username"];
//                
//                if ([arrWorksName isEqualToString:@"FitShare"]) {
//                    [searchedWorkouts addObject:workouts];
//                }
//            }
//            [typeArrworkouts removeAllObjects];
//            typeArrworkouts = [searchedWorkouts mutableCopy];
//        }
            break;
        default:
            break;
    }
    [WorkoutsFromDBTableView reloadData];
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
