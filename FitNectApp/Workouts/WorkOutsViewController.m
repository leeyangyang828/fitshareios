//
//  WorkOutsViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/26/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import "WorkOutsViewController.h"
#import "PreviewWorkOutsViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import Firebase;
@interface WorkOutsViewController (){
    NSMutableArray * searchedWorkouts;
}

@end

@implementation WorkOutsViewController

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
    
    searchedWorkouts = [[NSMutableArray alloc] init];
    searchedWorkouts =[_arrWorkoutsFromFireBase mutableCopy];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(onBackClick:)forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(26, 3, 70, 20)];
    [label setFont:[UIFont fontWithName:@"Ariral-BoldMT" size:17]];
    [label setText:@"FitNect"];
    label.textAlignment = UITextAlignmentCenter;
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [leftButton addSubview:label];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = barButton;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onWorkMenuClick:)];
    self.navigationItem.rightBarButtonItem = barButton1;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // [self.navigationController.navigationBar addSubview:navView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [searchedWorkouts count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *sortTableViewIdentifier = @"WorkOutsTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sortTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sortTableViewIdentifier];
    }
    cell.textLabel.text =[[searchedWorkouts objectAtIndex:indexPath.row] objectForKey:@"workoutsId"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[[_arrWorkoutsFromFireBase objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"likes"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dict = [_arrWorkoutsFromFireBase objectAtIndex:indexPath.row];
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
    
    searchedWorkouts =[_arrWorkoutsFromFireBase mutableCopy];
    [workoutsTableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [workoutsSearchBar resignFirstResponder];
    if (searchBar.text.length != 0) {
        searchedWorkouts = [NSMutableArray new];
        for (NSDictionary *workouts in _arrWorkoutsFromFireBase) {
            NSString *name = @"";
            name = [workouts objectForKey:@"workoutsId"];
            if ([[name lowercaseString] rangeOfString:searchBar.text.lowercaseString].location != NSNotFound) {
                [searchedWorkouts addObject:workouts];
            }
        }
    } else {
        [searchedWorkouts removeAllObjects];
        
        searchedWorkouts =[_arrWorkoutsFromFireBase mutableCopy];
    }
    
    [workoutsTableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length != 0) {
        searchedWorkouts = [NSMutableArray new];
        for (NSDictionary *workouts in _arrWorkoutsFromFireBase) {
            NSString *name = @"";
            name = [workouts objectForKey:@"workoutsId"];
            if ([[name lowercaseString] rangeOfString:searchText.lowercaseString].location != NSNotFound) {
                [searchedWorkouts addObject:workouts];
            }
        }
    } else {
        [searchedWorkouts removeAllObjects];
        searchedWorkouts =[_arrWorkoutsFromFireBase mutableCopy];
    }
    
    [workoutsTableView reloadData];
}

- (IBAction)onWorkMenuClick:(id)sender {
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
- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
