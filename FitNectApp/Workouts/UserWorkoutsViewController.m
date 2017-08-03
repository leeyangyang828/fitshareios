//
//  UserWorkoutsViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/27/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import "UserWorkoutsViewController.h"
#import "MBProgressHUD.h"
#import <Firebase/Firebase.h>
#import "OneWorkouksCurrentUserViewController.h"
@interface UserWorkoutsViewController ()
{
    NSMutableArray *getWorkouts;
}
@end

@implementation UserWorkoutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblUserName.text = _usernameForWorkous;
    
    getWorkouts = [[NSMutableArray alloc] init];
    
    [self getWorkoutsCurrentUser];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}
- (void)getWorkoutsCurrentUser{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://fitnect.firebaseio.com"];
//    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        NSDictionary *responseObject = snapshot.value[@"Workouts"];
//        for (NSString *workoutsId in responseObject) {
//            if ([workoutsId rangeOfString:_usernameForWorkous].location != NSNotFound) {
//                NSMutableDictionary *muDict = [[NSMutableDictionary alloc] init];
//                [muDict setObject:workoutsId forKey:@"workoutsId"];
//                [muDict setObject:[responseObject objectForKey:workoutsId] forKey:@"data"];
//                [getWorkouts addObject:muDict];
//            }
//        }
//       
//        [profileWorkoutsTableview reloadData];
//        
//    } withCancelBlock:^(NSError *error){
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        NSLog(@"%@", error.description);
//    }];
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
    return [getWorkouts count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *sortTableViewIdentifier = @"workoutCurrnetUserTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sortTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sortTableViewIdentifier];
    }
    cell.textLabel.text =[[[getWorkouts objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"workout"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dict = [getWorkouts objectAtIndex:indexPath.row];
    OneWorkouksCurrentUserViewController *previewWorkOutsViewController = [[OneWorkouksCurrentUserViewController alloc] initWithNibName:nil bundle:nil];
    previewWorkOutsViewController.infoSelectedWorkOuts =dict;
    [self.navigationController pushViewController:previewWorkOutsViewController animated:YES];
}

- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
