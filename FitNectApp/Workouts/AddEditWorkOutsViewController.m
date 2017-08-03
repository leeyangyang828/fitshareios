//
//  AddEditWorkOutsViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/26/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import "AddEditWorkOutsViewController.h"
#import "WorkOutsCell.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "SelectExerciseViewController.h"
#import "MBProgressHUD.h"
#import "RepsEditCell.h"
#import "RepsCell.h"
#import "RepsAndCommentViewController.h"

@import Firebase;
@interface AddEditWorkOutsViewController ()<WorkOutsCellDelegate, UITextViewDelegate, UITextFieldDelegate, SelectExerciseViewControllerDelegate>{
    
    NSMutableDictionary *arrAllWorkoutsForcurrentUser;
    NSMutableArray *madeExercies;
    NSMutableArray *madeSets;
    NSMutableArray *madeComments;
    NSMutableArray *madeReps;
    BOOL isTapComments;
    BOOL isSavedOnLocal;
    
    BOOL test;
    
    NSInteger currentSetsCount;
    
    NSMutableArray *searchHelpExercies;
    
    NSArray *arrayForST;
}

@end

@implementation AddEditWorkOutsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    isTapComments = NO;
    test = NO;
    searchHelpExercies = [[NSMutableArray alloc] init];
    arrAllWorkoutsForcurrentUser = [[NSMutableDictionary alloc] init];
    madeExercies = [[NSMutableArray alloc] init];
    madeSets = [[NSMutableArray alloc] init];
    madeComments = [[NSMutableArray alloc] init];
    madeReps = [[NSMutableArray alloc] init];
    
    txtExercise.text = @"";
    txtSets.text = @"";

    lblWorkoutsName.text = _workoutName;
    
    commentPreView.hidden = YES;
    if (_arrAddWorkouts) {        
        arrAllWorkoutsForcurrentUser = [[_arrAddWorkouts objectForKey:@"data"] mutableCopy];
        
        madeExercies = [[arrAllWorkoutsForcurrentUser objectForKey:@"exercise"] mutableCopy];
        madeComments = [[arrAllWorkoutsForcurrentUser objectForKey:@"comment"] mutableCopy];
        madeReps = [[arrAllWorkoutsForcurrentUser objectForKey:@"reps"] mutableCopy];
        madeSets = [[arrAllWorkoutsForcurrentUser objectForKey:@"sets"] mutableCopy];
     
        _workoutName = [arrAllWorkoutsForcurrentUser objectForKey:@"workoutname"];
        _workoutType = [arrAllWorkoutsForcurrentUser objectForKey:@"goal"];
        _workoutsImageUrl = [arrAllWorkoutsForcurrentUser objectForKey:@"workoutImageUrl"];
    }
    NSInteger index = 0;
    NSMutableArray *availReps = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[arrAllWorkoutsForcurrentUser objectForKey:@"sets"] count]; i ++) {
        NSMutableArray *lineReps = [[NSMutableArray alloc] init];
        NSString *oneSets = [[arrAllWorkoutsForcurrentUser objectForKey:@"sets"] objectAtIndex:i];
        [lineReps addObject:oneSets];
        NSArray *parseSets = [oneSets componentsSeparatedByString:@" "];
        if ([parseSets[[parseSets count]-1] isEqualToString:@"Sets"]) {
            for (int j = 0; j < [parseSets[0] integerValue]; j ++) {
                if ([[arrAllWorkoutsForcurrentUser objectForKey:@"reps"] objectAtIndex:index+j])
                    [lineReps addObject:[[arrAllWorkoutsForcurrentUser objectForKey:@"reps"] objectAtIndex:index+j]];
            }
        }
        index = index + [parseSets[0] integerValue];
        NSArray *arryLineRes = [lineReps copy];
        [availReps addObject:arryLineRes];
    }
    
    arrayForST = [availReps copy];
    _AddOfCurrentUserTableView.SKSTableViewDelegate = self;
    isShared = NO;
    isSavedOnLocal = NO;
    [selectedRepsSets setOn:NO];
    _helpForExerciseTableView.hidden = YES;
    currentSetsCount = 0;
    lstHelpForExercise = [[NSArray alloc] initWithObjects:@"Abs", @"Back",@"Biceps",@"Cardio", @"Chest", @"Legs", @"Shoulders",@"Triceps", nil];
    searchHelpExercies = [lstHelpForExercise mutableCopy];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(btBackClick:)forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(26, 3, 135, 20)];
    [label setFont:[UIFont fontWithName:@"Ariral-BoldMT" size:17]];
    [label setText:_workoutName];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [leftButton addSubview:label];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = barButton;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save"] style:UIBarButtonItemStylePlain target:self action:@selector(btSaveClick:)];
    UIBarButtonItem *barButton2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sharewhite"] style:UIBarButtonItemStylePlain target:self action:@selector(btLinkClick:)];
//    UIBarButtonItem *barButton3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"note"] style:UIBarButtonItemStylePlain target:self action:@selector(btAddCommentsClick:)];
    UIBarButtonItem *barButton4 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(btMenuClick:)];
    self.navigationItem.rightBarButtonItems = @[barButton4, barButton2, barButton1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.navigationController.navigationBar addSubview:navView];
//    txtExercise.text = [AppDelegate sharedDelegate].currentHelpforExercies;
    if ([AppDelegate sharedDelegate].isSelectedCar) {
        //txtSets.placeholder = @"Min.";
        lblTypeCardio.text = @"How many minutes?";
        [selectedRepsSets setOn:YES];
    }else{
        //txtSets.placeholder = @"Sets";
        lblTypeCardio.text = @"How many sets?";
        [selectedRepsSets setOn:NO];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[navView removeFromSuperview];
}
-(IBAction)btSaveClick:(id)sender{
    
    [self.view endEditing:NO];
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    NSFetchRequest *allContacts = [[NSFetchRequest alloc] init];
    [allContacts setEntity:[NSEntityDescription entityForName:@"Workouts" inManagedObjectContext:context]];
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:allContacts error:&error];
    NSArray *foundLocations = [fetchedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", _workoutName]];
    
    NSError *saveError = nil;
    if (foundLocations.count > 0) {
        for (Workouts *workouts in foundLocations) {
            [context deleteObject:workouts];
        }
        
        [context save:&saveError];
        if (saveError) {
            NSLog(@"Error when saving managed object context : %@", saveError);
        }
    }
    Workouts *workouts = [NSEntityDescription insertNewObjectForEntityForName:@"Workouts" inManagedObjectContext:context];
    workouts.userId = [AppDelegate sharedDelegate].sessionId;
    workouts.title = _workoutName;
    workouts.typeWorkouts = @1;
    workouts.data = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrAllWorkoutsForcurrentUser options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    
    [context save:&saveError];
    if (saveError) {
        NSLog(@"Error when saving managed object context : %@", saveError);
    }
    [self showAlert:@"Workouts saved!" :@"Success!" :nil];
    isSavedOnLocal = YES;
    //[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView tag] == 102 && buttonIndex == 1)
    {
        FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
        
        FIRDatabaseReference *rootRForHaveingSharedNum = [rootR child:@"user info"];
        if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
            FIRDatabaseReference *rootRForAdding = [rootRForHaveingSharedNum child:[AppDelegate sharedDelegate].userName];
            
            NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
            NSUInteger num = [[AppDelegate sharedDelegate].sharedNumber integerValue];
            num++;
            [AppDelegate sharedDelegate].sharedNumber = [NSString stringWithFormat:@"%lu", (unsigned long)num];
            
            [[AppDelegate sharedDelegate] saveLoginData];
            
            [userInfoForPost setValue:[AppDelegate sharedDelegate].userEmail forKey:@"email"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].userFirstName forKey:@"firstName"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].userLastName forKey:@"lastName"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].userName forKey:@"username"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].curUserProfileImageUrl forKey:@"profileUrl"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].completeNumber forKey:@"completeNumber"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].sharedNumber forKey:@"sharedNumber"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].goal forKey:@"goal"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].currentGym forKey:@"gym"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].aboutMe forKey:@"aboutMe"];
            [rootRForAdding setValue:userInfoForPost];
        }
        
        
        
        FIRDatabaseReference *rootRForSharedWorkouts;
        if ([_workoutType isEqualToString:@"Strength Training"]) {
            rootRForSharedWorkouts = [rootR child:@"Strength Training"];
        } else if ([_workoutType isEqualToString:@"Cardio Training"]) {
            rootRForSharedWorkouts = [rootR child:@"Cardio Training"];
        }else if ([_workoutType isEqualToString:@"Trainer Workout"]) {
            rootRForSharedWorkouts = [rootR child:@"Trainer Workout"];
        }
        
        NSMutableDictionary *userInfoForShared = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *arrExercies = [[NSMutableArray alloc] init];
        NSMutableArray *arrReps = [[NSMutableArray alloc] init];
        NSMutableArray *arrSets = [[NSMutableArray alloc] init];
        NSMutableArray *arrComments = [[NSMutableArray alloc] init];
        
    
        arrComments = [arrAllWorkoutsForcurrentUser objectForKey:@"comment"];
        arrExercies = [arrAllWorkoutsForcurrentUser objectForKey:@"exercise"];
        arrReps = [arrAllWorkoutsForcurrentUser objectForKey:@"reps"];
        arrSets = [arrAllWorkoutsForcurrentUser objectForKey:@"sets"];
        
        
        
        NSString *likes = 0;
        NSLog(@"arraytosting : %@", [NSString stringWithFormat:@"%@", arrComments]);
        NSString *strComments = @"";
        for (int i = 0; i < [arrComments count]; i ++) {
            NSString *one = [arrComments objectAtIndex:i];
            if (i == 0) {
                strComments = [NSString stringWithFormat:@"[%@", one];
            }else if (i == [arrComments count]-1){
                strComments = [NSString stringWithFormat:@"%@, %@]", strComments, one];
            }else{
                strComments = [NSString stringWithFormat:@"%@, %@", strComments, one];
            }
            if ([arrComments count] == 1) {
                strComments = [NSString stringWithFormat:@"%@]", strComments];
            }
        }
        [userInfoForShared setValue:strComments forKey:@"comment"];
        
        NSString *strExercise = @"";
        for (int i = 0; i < [arrExercies count]; i ++) {
            NSString *one = [arrExercies objectAtIndex:i];
            if (i == 0) {
                strExercise = [NSString stringWithFormat:@"[%@", one];
            }else if (i == [arrExercies count]-1){
                strExercise = [NSString stringWithFormat:@"%@, %@]", strExercise, one];
            }else{
                strExercise = [NSString stringWithFormat:@"%@, %@", strExercise, one];
            }
            if ([arrExercies count] == 1) {
                strExercise = [NSString stringWithFormat:@"%@]", strExercise];
            }
        }
        [userInfoForShared setValue:strExercise forKey:@"exercise"];
        
        NSString *strReps = @"";
        for (int i = 0; i < [arrReps count]; i ++) {
            NSString *one = [arrReps objectAtIndex:i];
            if (i == 0) {
                strReps = [NSString stringWithFormat:@"[%@", one];
            }else if (i == [arrReps count]-1){
                strReps = [NSString stringWithFormat:@"%@, %@]", strReps, one];
            }else{
                strReps = [NSString stringWithFormat:@"%@, %@", strReps, one];
            }
            if ([arrReps count] == 1) {
                strReps = [NSString stringWithFormat:@"%@]", strReps];
            }
        }
        [userInfoForShared setValue:strReps forKey:@"reps"];
        
        
        NSString *strSets = @"";
        for (int i = 0; i < [arrSets count]; i ++) {
            NSString *one = [arrSets objectAtIndex:i];
            if (i == 0) {
                strSets = [NSString stringWithFormat:@"[%@", one];
            }else if (i == [arrSets count]-1){
                strSets = [NSString stringWithFormat:@"%@, %@]", strSets, one];
            }else{
                strSets = [NSString stringWithFormat:@"%@, %@", strSets, one];
            }
            if ([arrSets count] == 1) {
                strSets = [NSString stringWithFormat:@"%@]", strSets];
            }
        }
        [userInfoForShared setValue:strSets forKey:@"sets"];
        
        [userInfoForShared setValue:@0 forKey:@"likes"];
        [userInfoForShared setValue:[AppDelegate sharedDelegate].userName forKey:@"username"];
        [userInfoForShared setValue:_workoutName forKey:@"workout"];
        [userInfoForShared setValue:[AppDelegate sharedDelegate].goal forKey:@"goal"];
        
        if (_workoutsImageUrl && ![_workoutsImageUrl isEqualToString:@""]) {
            [userInfoForShared setValue:_workoutsImageUrl forKey:@"image"];
        }
        FIRDatabaseReference *postRef = [rootRForSharedWorkouts childByAutoId];
        [postRef setValue:userInfoForShared];
        
        //    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://fitnect.firebaseio.com"];
        //    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
        //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //        if (!isShared) {
        //            Firebase *addUser = [myRootRef childByAppendingPath:@"Workouts"];
        //            //            NSDictionary *post1 = @{
        //            //                                    @"email":@"jellastar@gmail.com",
        //            //                                    @"firstName":@"jella",
        //            //                                    @"lastName":@"star",
        //            //                                    @"password":@"jellastar1023",
        //            //                                    @"username":@"jellastar"
        //            //                                    };
        //
        //            NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
        //
        //            NSMutableArray *arrExercies = [[NSMutableArray alloc] init];
        //            NSMutableArray *arrReps = [[NSMutableArray alloc] init];
        //            NSMutableArray *arrSets = [[NSMutableArray alloc] init];
        //
        //
        //            for (NSDictionary *dict in arrAllWorkouts) {
        //                [arrExercies addObject:[dict objectForKey:@"exercise"]];
        //                [arrReps addObject:[dict objectForKey:@"reps"]];
        //                [arrSets addObject:[dict objectForKey:@"sets"]];
        //            }
        //
        //            NSString *likes = 0;
        //            [userInfoForPost setValue:commentsTextView.text forKey:@"comment"];
        //            [userInfoForPost setValue:[[[[[NSString stringWithFormat:@"%@", arrExercies] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"(" withString:@"["] stringByReplacingOccurrencesOfString:@")" withString:@"]"] forKey:@"exercise"];
        //            //[userInfoForPost setValue:likes forKeyPath:@"likes"];
        //            [userInfoForPost setValue:[[[[[NSString stringWithFormat:@"%@", arrReps] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"(" withString:@"["] stringByReplacingOccurrencesOfString:@")" withString:@"]"] forKey:@"reps"];
        //            [userInfoForPost setValue:[[[[[NSString stringWithFormat:@"%@", arrSets] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"(" withString:@"["] stringByReplacingOccurrencesOfString:@")" withString:@"]"] forKey:@"sets"];
        //            [userInfoForPost setValue:@0 forKey:@"likes"];
        //            [userInfoForPost setValue:[AppDelegate sharedDelegate].userName forKey:@"username"];
        //            [userInfoForPost setValue:txtWorkoutsTitle.text forKey:@"workout"];
        //
        //            Firebase *postRef = [addUser childByAppendingPath:[NSString stringWithFormat:@"%@:%@",txtWorkoutsTitle.text,[AppDelegate sharedDelegate].userName ]];
        //            [postRef setValue:userInfoForPost];
        //            isShared = YES;
        //        }
        //
        //    } withCancelBlock:^(NSError *error){
        //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //        NSLog(@"%@", error.description);
        //    }];
    }
}
-(IBAction)btLinkClick:(id)sender{
    if ([AppDelegate sharedDelegate].completeNumber > 0) {
        [self.view endEditing:NO];
        if (!isSavedOnLocal) {
            [self btSaveClick:nil];
        }
        isSavedOnLocal = NO;
        isShared = NO;
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Share now" message:@"Would you like to share this workout?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alertView setTag:102];
        [alertView show];
    }else{
        [self showAlert:@"Please complete at least 1 workout before sharing your own" :@"" :nil];
    }
    
}
-(IBAction)btMenuClick:(id)sender{
    
    [self.view endEditing:NO];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Setting", @"Logout", nil];
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
            [[AppDelegate sharedDelegate] deleteLoginData];
            [[AppDelegate sharedDelegate] goToSplash];
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
-(IBAction)btBackClick:(id)sender{
    [[AppDelegate sharedDelegate] goToMainContact];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _helpForExerciseTableView) {
        return [searchHelpExercies count];
    }else if (tableView == _AddOfCurrentUserTableView){
        NSLog(@"index : %lu",(unsigned long)[arrayForST count]);
        return [arrayForST count];
    }
    return 0;
}
- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_AddOfCurrentUserTableView]) {
        return [arrayForST[indexPath.row] count] - 1;
    }
    return 0;
}
- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_AddOfCurrentUserTableView]) {
        if (indexPath.section == 1 && indexPath.row == 0)
        {
            return YES;
        }
        
        return NO;
    }
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _helpForExerciseTableView) {
        return 44.0f;
    }
    return 82.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _helpForExerciseTableView) {
        static NSString *helpForExercieTableViewIdentifier = @"HelpForExerciseTableItem";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:helpForExercieTableViewIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:helpForExercieTableViewIdentifier];
        }
        cell.textLabel.text =[searchHelpExercies objectAtIndex:indexPath.row];
        
        return cell;
    }else if ([tableView isEqual:_AddOfCurrentUserTableView]) {
        static NSString *simpleTableIdentifier = @"WorkoutCell";
        WorkOutsCell *cell = [_AddOfCurrentUserTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [WorkOutsCell sharedCell];
        }
        
        cell.resDelegate = self;
        if ([arrayForST[indexPath.row] count] > 0)
            cell.expandable = YES;
        else
            cell.expandable = NO;
        [cell setCurWorkoutsItem:[[arrAllWorkoutsForcurrentUser objectForKey:@"comment"] objectAtIndex:indexPath.row]];
        
        [cell.txtExercise setText:[[arrAllWorkoutsForcurrentUser objectForKey:@"exercise"] objectAtIndex:indexPath.row]];
        [cell.txtSets setText:[[arrAllWorkoutsForcurrentUser objectForKey:@"sets"] objectAtIndex:indexPath.row]];
        NSLog(@"testing : %@", [[arrAllWorkoutsForcurrentUser objectForKey:@"exercise"] objectAtIndex:indexPath.row]);
        return cell;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_AddOfCurrentUserTableView]) {
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
    return nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:NO];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _helpForExerciseTableView) {
        _helpForExerciseTableView.hidden = YES;
        SelectExerciseViewController *selectExerciseViewController = [[SelectExerciseViewController alloc] initWithNibName:@"SelectExerciseViewController" bundle:nil];
        for (int i = 0 ; i < [lstHelpForExercise count]; i ++) {
            if ([[lstHelpForExercise objectAtIndex:i] isEqualToString:[searchHelpExercies objectAtIndex:indexPath.row]]) {
                selectExerciseViewController.indexSelectedExercies =i+1;
            }
        }
        selectExerciseViewController.exerciseDelegate = self;
        [self presentViewController:selectExerciseViewController animated:YES completion:nil];
        
    }
}
- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
}

- (IBAction)onAdd:(id)sender {
    [self.view endEditing:NO];
    if (!txtExercise.text.length || !txtSets.text.length) {
        [self showAlert:@"Fill in all spaces before adding to list!" :@"Input Error" :nil];
        return;
    }
    
    [madeExercies addObject:txtExercise.text];
    if ([AppDelegate sharedDelegate].isSelectedCar || selectedRepsSets.selected) {
        [madeSets addObject:[NSString stringWithFormat:@"%@ Minutes",txtSets.text]];
        for (int i = 0; i < [txtSets.text integerValue]; i ++) {
            [madeReps addObject:@"Cardio"];
        }
    }else{
        [madeSets addObject:[NSString stringWithFormat:@"%@ Sets",txtSets.text]];
    }
    [arrAllWorkoutsForcurrentUser setObject:madeExercies forKey:@"exercise"];
    [arrAllWorkoutsForcurrentUser setObject:madeSets forKey:@"sets"];
    [arrAllWorkoutsForcurrentUser setObject:madeComments forKey:@"comment"];
    [arrAllWorkoutsForcurrentUser setObject:madeReps forKey:@"reps"];
    [arrAllWorkoutsForcurrentUser setObject:_workoutType forKey:@"goal"];
    [arrAllWorkoutsForcurrentUser setObject:_workoutName forKey:@"workoutname"];
    [arrAllWorkoutsForcurrentUser setObject:_workoutsImageUrl forKey:@"workoutImageUrl"];
    
    NSMutableDictionary *arrSendWorkouts = [[NSMutableDictionary alloc] init];
    [arrSendWorkouts setObject:arrAllWorkoutsForcurrentUser forKey:@"data"];
    [arrSendWorkouts setObject:_workoutName forKey:@"title"];
    RepsAndCommentViewController *vc = [[RepsAndCommentViewController alloc] initWithNibName:nil bundle:nil];
    vc.arrWorkoutsCreated = arrSendWorkouts;
    vc.exercise = txtExercise.text;
    vc.sets = txtSets.text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onSelectedRepsSets:(id)sender {
    selectedRepsSets.selected = !selectedRepsSets.selected;
    if (selectedRepsSets.selected){
        //txtSets.placeholder = @"Min.";
        lblTypeCardio.text = @"How many minutes?";
        [AppDelegate sharedDelegate].isSelectedCar = YES;
    }else{
        //txtSets.placeholder = @"Sets";
        lblTypeCardio.text = @"How many sets?";
        [AppDelegate sharedDelegate].isSelectedCar = NO;
    }
}

- (IBAction)onCommentPreviewClose:(id)sender {
    commentPreView.hidden = YES;
}

-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark WorkOutsCellDelegate
- (void)didComments:(NSString *)workoutsDict{
    commentPreView.hidden = NO;
    lblSelectedComment.text = workoutsDict;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txtExercise){
        [txtSets becomeFirstResponder];
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    else if (textField == txtSets){
        [self onAdd:nil];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == txtExercise){
        [textField setKeyboardType:UIKeyboardTypeDefault];
        _helpForExerciseTableView.hidden = NO;
        [searchHelpExercies removeAllObjects];
        searchHelpExercies = [lstHelpForExercise mutableCopy];
        [_helpForExerciseTableView reloadData];
    }
    else if (textField == txtSets){
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
}
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    NSString *compareStr = @"";
    if (range.location == txtExercise.text.length) {
        compareStr  = [txtExercise.text stringByAppendingString:string];
    }else if (range.location == txtExercise.text.length-1){
        compareStr = [txtExercise.text substringToIndex:txtExercise.text.length-1];
    }
    
    if (textField == txtExercise){
        CGFloat size = [self widthOfString:txtExercise.text withFont:[UIFont fontWithName:@"Helvetica" size:14]];
        if (size > txtExercise.bounds.size.width) {
           
        }
        if ([compareStr isEqualToString:@""])
        {
            [searchHelpExercies removeAllObjects];
            [_helpForExerciseTableView reloadData];
            _helpForExerciseTableView.hidden = YES;
        }
        else
        {
            [searchHelpExercies removeAllObjects];
            for (int i = 0 ; i < [lstHelpForExercise count] ; i++)
            {
                NSString * dict = [lstHelpForExercise objectAtIndex:i];
                NSRange range = [[dict uppercaseString] rangeOfString:[compareStr uppercaseString]];
                if (range.location != NSNotFound) {
                    [searchHelpExercies addObject:dict];
                }
            }
            if ([searchHelpExercies count] == 0) {
                _helpForExerciseTableView.hidden = YES;
            }
            [self updateTableViewHeight];
            _helpForExerciseTableView.hidden = NO;
            [_helpForExerciseTableView reloadData];
        }
    }
    else if (textField == txtSets){
        if (txtSets.text.length>1) {
            return NO;
        }
    }
    return  YES;
}
- (void)updateTableViewHeight{
    [_helpForExerciseTableView setFrame:CGRectMake(_helpForExerciseTableView.frame.origin.x, _helpForExerciseTableView.frame.origin.y, _helpForExerciseTableView.frame.size.width, 44 * [searchHelpExercies count])];
}

#pragma Mark SelectExerciseViewControllerDelegate
-(void)getExercise:(NSString *)selectedExercise{
    txtExercise.text = selectedExercise;
}


@end
