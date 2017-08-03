//
//  MyWorkoutsListViewController.m
//  FitNectApp
//
//  Created by stepanekdavid on 12/29/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "MyWorkoutsListViewController.h"
#import "SettingViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UIImageView+AFNetworking.h"
#import "OwnWorkoutCell.h"
#import "FirstpageForAddingWorkoutViewController.h"
#import "AddEditWorkOutsViewController.h"
#import "PreviewWorkOutsViewController.h"
@import Firebase;
@import FirebaseStorage;
@interface MyWorkoutsListViewController ()<UIAlertViewDelegate, UIActionSheetDelegate>{
    NSMutableArray *arrayWorkouts;
    NSIndexPath *indexPathForDeleting;
    int typeForActionsheet;
}

@end

@implementation MyWorkoutsListViewController
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
    typeForActionsheet = 1;
    indexPathForDeleting = nil;
    arrayWorkouts = [[NSMutableArray alloc] init];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressItem:)];
    [MyWorkoutsTableView addGestureRecognizer:longPress];
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
    [self.navigationController.navigationBar addSubview:navView];
    [self getWorkouts];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getWorkouts{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    NSFetchRequest *allContacts = [[NSFetchRequest alloc] init];
    [allContacts setEntity:[NSEntityDescription entityForName:@"Workouts" inManagedObjectContext:context]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:allContacts error:&error];
    NSArray *foundLocations = [fetchedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId == %@", [NSString stringWithFormat:@"%@", [AppDelegate sharedDelegate].sessionId]]];
    
    [arrayWorkouts removeAllObjects];
    for (Workouts *workouts in foundLocations) {
        NSMutableDictionary *oneWorkouts = [[NSMutableDictionary alloc] init];
        [oneWorkouts setValue:workouts.title forKey:@"title"];
        id parsed = [NSJSONSerialization JSONObjectWithData:[workouts.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        [oneWorkouts setValue:parsed forKey:@"data"];
        [oneWorkouts setValue:workouts.typeWorkouts forKey:@"typeWorkouts"];
        [arrayWorkouts addObject:oneWorkouts];
    }
    if (arrayWorkouts.count > 0) {
        emptyLaberForWorkouts.hidden = YES;
        MyWorkoutsTableView.hidden = NO;
    }else{
        emptyLaberForWorkouts.hidden = NO;
        MyWorkoutsTableView.hidden = YES;
    }
    [MyWorkoutsTableView reloadData];
}

- (IBAction)onAddWorkouts:(id)sender {
    FirstpageForAddingWorkoutViewController *addEditWorkOutsViewController = [[FirstpageForAddingWorkoutViewController alloc] initWithNibName:nil bundle:nil];
    //[self presentViewController:loginViewController animated:YES completion:NULL];
    [self.navigationController pushViewController:addEditWorkOutsViewController animated:YES];
}

- (IBAction)onMenu:(id)sender {
    typeForActionsheet = 1;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Logout", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }
    if (typeForActionsheet == 1) {
        switch (buttonIndex) {
            case 1:
            {
                SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
                [self presentViewController:viewController animated:YES completion:nil];
            }
                break;
            case 0:{
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayWorkouts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"OwnWorkoutItem";
    OwnWorkoutCell *cell = [MyWorkoutsTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [OwnWorkoutCell sharedCell];
    }
        NSDictionary *dict = [arrayWorkouts objectAtIndex:indexPath.row];
        [cell setCurWorkoutsItem:dict];
        cell.workoutName.text =[dict objectForKey:@"title"];
        if ([[dict objectForKey:@"data"] objectForKey:@"workoutImageUrl"]) {
            if ([[[dict objectForKey:@"data"] objectForKey:@"workoutImageUrl"] rangeOfString:@"http"].location != NSNotFound) {
                [cell.workoutImage setImageWithURL:[NSURL URLWithString:[[dict objectForKey:@"data"] objectForKey:@"workoutImageUrl"]]];
            }else{
                [cell.workoutImage setImage:[UIImage imageNamed:@"workout_logo.png"]];
            }
        }else{
            [cell.workoutImage setImage:[UIImage imageNamed:@"workout_logo.png"]];
        }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"jella");
        NSMutableDictionary *dict = [arrayWorkouts objectAtIndex:indexPath.row];
        if ([[dict objectForKey:@"typeWorkouts"] boolValue]) {
            AddEditWorkOutsViewController *addEditWorkOutsViewController = [[AddEditWorkOutsViewController alloc] initWithNibName:nil bundle:nil];
            addEditWorkOutsViewController.arrAddWorkouts =dict;
            [self.navigationController pushViewController:addEditWorkOutsViewController animated:YES];
        }else{
            PreviewWorkOutsViewController *previewWorkOutsViewController = [[PreviewWorkOutsViewController alloc] initWithNibName:nil bundle:nil];
            previewWorkOutsViewController.infoSelectedWorkOuts =[dict objectForKey:@"data"];
            [self.navigationController pushViewController:previewWorkOutsViewController animated:YES];
        }
}
- (void)longPressItem:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:MyWorkoutsTableView];
    indexPathForDeleting = [MyWorkoutsTableView indexPathForRowAtPoint:p];
    
    if (indexPathForDeleting == nil) {
        NSLog(@"long press on table view but not on a row");
    }else if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        if (arrayWorkouts.count >0) {
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Delete this workout?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alertView setTag:101];
            [alertView show];
        }
    }else {
        NSLog(@"gesutreRevognizer.state = %ld", (long)gestureRecognizer.state);
    }
}
#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView tag] == 101 && buttonIndex == 1)
    {
        
        NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
        
        NSFetchRequest *allContacts = [[NSFetchRequest alloc] init];
        [allContacts setEntity:[NSEntityDescription entityForName:@"Workouts" inManagedObjectContext:context]];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:allContacts error:&error];
        NSArray *foundLocations = [fetchedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId == %@", [NSString stringWithFormat:@"%@", [AppDelegate sharedDelegate].sessionId]]];
        
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
        
        [arrayWorkouts removeObjectAtIndex:indexPathForDeleting.row];
        
        for (NSDictionary *dict in arrayWorkouts) {
            Workouts *workouts = [NSEntityDescription insertNewObjectForEntityForName:@"Workouts" inManagedObjectContext:context];
            workouts.userId = [AppDelegate sharedDelegate].sessionId;
            workouts.title = [dict objectForKey:@"title"];
            workouts.typeWorkouts = [dict objectForKey:@"typeWorkouts"];
            workouts.data = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[dict objectForKey:@"data"] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            
            NSError *saveError = nil;
            [context save:&saveError];
            if (saveError) {
                NSLog(@"Error when saving managed object context : %@", saveError);
            }
            
        }
        
        if (arrayWorkouts.count > 0) {
            emptyLaberForWorkouts.hidden = YES;
            MyWorkoutsTableView.hidden = NO;
        }else{
            emptyLaberForWorkouts.hidden = NO;
            MyWorkoutsTableView.hidden = YES;
        }
        [MyWorkoutsTableView reloadData];
        
    }
}
@end
