//
//  SelectGYMViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/25/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import "SelectGYMViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"

@import Firebase;

@interface SelectGYMViewController ()<UIActionSheetDelegate>{
    NSMutableArray * searchedGyms;
}

@end

@implementation SelectGYMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lstGym = [[NSArray alloc] initWithObjects:@"Gym not listed(can change later)",@"ATC Fitness Cape Coral Club",@"ATC Fitness Boyscout Club",@"ATC Fitness Six Mile Club",@"ATC Fitness Alico Club",@"ATC Fitness Port Charlotte Club",@"FGCU Fitness Center", nil];
    searchedGyms = [[NSMutableArray alloc] init];
    searchedGyms = [lstGym mutableCopy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (IS_IPHONE_5) {
        [navView setFrame:CGRectMake(0, 0, 320, 44)];
    }else{
        
        [navView setFrame:CGRectMake(0, 0, self.view.superview.frame.size.width, 44)];
    }
    [self.navigationController.navigationBar addSubview:navView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Please select your gym:";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [searchedGyms count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *sortTableViewIdentifier = @"GymTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sortTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sortTableViewIdentifier];
    }
    cell.textLabel.text =[searchedGyms objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [AppDelegate sharedDelegate].currentGym = [searchedGyms objectAtIndex:indexPath.row];
    [AppDelegate sharedDelegate].isLoginOrRegister = NO;
    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
//    FIRDatabaseReference *rootRForCreatingGYM = [rootR child:[searchedGyms objectAtIndex:indexPath.row]];
//    FIRDatabaseReference *rootRForAddingGYM = [rootRForCreatingGYM childByAutoId];
//    
//    NSMutableDictionary *userInfoForPostGYM = [[NSMutableDictionary alloc] init];
//    [userInfoForPostGYM setValue:[AppDelegate sharedDelegate].userName forKey:@"username"];
//    [rootRForAddingGYM setValue:userInfoForPostGYM];
    
    [[AppDelegate sharedDelegate] saveLoginData];
    
    NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
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
    if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
    FIRDatabaseReference *rootRForResgiter = [[rootR child:@"user info"] child:[AppDelegate sharedDelegate].userName];
    [rootRForResgiter setValue:userInfoForPost];
    }
    
    [[AppDelegate sharedDelegate] goToMainContact];
    
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
    
    [searchedGyms removeAllObjects];
    
    searchedGyms =[lstGym mutableCopy];
    [gymTableview reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [gymSearchBar resignFirstResponder];
    if (searchBar.text.length != 0) {
        searchedGyms = [NSMutableArray new];
        for (NSString *gyms in lstGym) {
            if ([[gyms lowercaseString] rangeOfString:searchBar.text.lowercaseString].location != NSNotFound) {
                [searchedGyms addObject:gyms];
            }
        }
    } else {
        [searchedGyms removeAllObjects];
        
        searchedGyms =[lstGym mutableCopy];
    }
    
    [gymTableview reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length != 0) {
        searchedGyms = [NSMutableArray new];
        for (NSString *gyms in lstGym) {
            if ([[gyms lowercaseString] rangeOfString:searchBar.text.lowercaseString].location != NSNotFound) {
                [searchedGyms addObject:gyms];
            }
        }
    } else {
        [searchedGyms removeAllObjects];
        searchedGyms =[lstGym mutableCopy];
    }
    
    [gymTableview reloadData];
}
- (IBAction)onGYMMenuClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Setting", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1) {
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
        default:
            break;
    }
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}
@end
