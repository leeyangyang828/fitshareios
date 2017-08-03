//
//  NotificationViewController.m
//  FitNectApp
//
//  Created by stepanekdavid on 11/10/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "NotificationViewController.h"
#import "SettingViewController.h"
@import Firebase;
@interface NotificationViewController (){
    NSMutableArray *arrNotifications;
}

@end

@implementation NotificationViewController
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
    UIBarButtonItem *barButton4 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(btMenuClick:)];
    self.navigationItem.rightBarButtonItem = barButton4;
    
    arrNotifications = [[NSMutableArray alloc] init];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getnotificationsForOwn];
}
-(void)getnotificationsForOwn{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/Strength Training"];
    [[rootR queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = snapshot.value;
        for (NSString *snap in dict) {
            NSDictionary *oneNotification = [dict objectForKey:snap];
            if ([oneNotification objectForKey:@"notifReceiver"] && [[oneNotification objectForKey:@"notifReceiver"] isEqualToString:[AppDelegate sharedDelegate].userName]) {
                [arrNotifications addObject:oneNotification];
            }
        }
        [NotificationTableView reloadData];
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

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([arrNotifications count] > 0) {
        return @"Notifications";
    }else{
        return @"No new notifications at this time";
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrNotifications count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *sortTableViewIdentifier = @"NotificationItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sortTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sortTableViewIdentifier];
    }
    NSDictionary *dict = [arrNotifications objectAtIndex:indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"%@ has liked your workout, %@", [dict objectForKey:@"notifSender"], [dict objectForKey:@"notifWorkout"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
