//
//  BeginWorkoutsViewController.m
//  FitNectApp
//
//  Created by stepanekdavid on 8/23/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "BeginWorkoutsViewController.h"
#import "RepsCell.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
@import Firebase;
@interface BeginWorkoutsViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate, UIAlertViewDelegate>{
    NSMutableArray *arrBeginingALLExercies;
    int steps;
}

@end

@implementation BeginWorkoutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrBeginingALLExercies = [[NSMutableArray alloc] init];
    steps = 0;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"abc_ic_ab_back_mtrl_am_alpha"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(onBackClick:)forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(26, 3, 200, 20)];
    [label setFont:[UIFont fontWithName:@"Ariral-BoldMT" size:17]];
    [label setText:[_beginingArray objectForKey:@"workout"]];
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
    
    _beginUserName.text = [_beginingArray objectForKey:@"username"];
    
    NSInteger index = 0;
    
    for (int i = 0; i < [[_beginingArray objectForKey:@"comment"] count]; i ++) {
        NSMutableDictionary *oneExerices = [[NSMutableDictionary alloc] init];
        [oneExerices setValue:[[_beginingArray objectForKey:@"exercise"] objectAtIndex:i] forKey:@"exercies"];
        [oneExerices setValue:[[_beginingArray objectForKey:@"comment"] objectAtIndex:i] forKey:@"comment"];
        [oneExerices setValue:[[_beginingArray objectForKey:@"sets"] objectAtIndex:i] forKey:@"sets"];
        
            NSMutableArray *lineReps = [[NSMutableArray alloc] init];
            NSString *oneSets = [[_beginingArray objectForKey:@"sets"] objectAtIndex:i];
            NSArray *parseSets = [oneSets componentsSeparatedByString:@" "];
            if ([parseSets[[parseSets count]-1] isEqualToString:@"Sets"]) {
                for (int k = 0; k < [parseSets[0] integerValue]; k ++) {
                    if ([[_beginingArray objectForKey:@"reps"] objectAtIndex:index+k])
                        [lineReps addObject:[[_beginingArray objectForKey:@"reps"] objectAtIndex:index+k]];
                    
                }
            }
            index = index + [parseSets[0] integerValue];

        [oneExerices setValue:lineReps forKey:@"reps"];

        
        
        [arrBeginingALLExercies addObject:oneExerices];
    }
    
    [self setWorkoutsBeginStep:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onPreviewMenu:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save", @"View Profile", @"Setting", @"Logout", nil];
    [actionSheet showInView:self.view];
}
- (IBAction)onLookTutorial:(id)sender {
    NSString *urlAddress = [NSString stringWithFormat:@"http://www.google.com/search?q=%@+Tutorial",[[_beginExerciese.text stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByReplacingOccurrencesOfString:@"\n" withString:@"+"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddress]];
}
- (IBAction)onBackStep:(id)sender {
    steps --;
    [self setWorkoutsBeginStep:steps];
}
- (IBAction)onNextSteps:(id)sender {
    steps ++;
    [self setWorkoutsBeginStep:steps];
}
- (void)setWorkoutsBeginStep:(int)step{
    if (step == 0) {
        _btnBackSteps.hidden = YES;
    }else{
        _btnBackSteps.hidden = NO;
        if (step == arrBeginingALLExercies.count) {
            _btnNextSteps.hidden = YES;
            [self oneWorkoutsCompleted];
            return;
        }else{
            _btnNextSteps.hidden = NO;
            
        }
    }
    if (step < arrBeginingALLExercies.count) {
        
        NSDictionary *dict = [arrBeginingALLExercies objectAtIndex:step];
        _beginExerciese.text = [dict objectForKeyedSubscript:@"exercies"];
        _beginComment.text = [dict objectForKey:@"comment"];
    }
    [_RepsTableview reloadData];
}
- (void)oneWorkoutsCompleted{
    
    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
    
    FIRDatabaseReference *rootRForHaveingcompletedNum = [rootR child:@"user info"];
    if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
        FIRDatabaseReference *rootRForAdding = [rootRForHaveingcompletedNum child:[AppDelegate sharedDelegate].userName];
        
        NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
        NSUInteger num = [[AppDelegate sharedDelegate].completeNumber integerValue];
        num++;
        [AppDelegate sharedDelegate].completeNumber = [NSString stringWithFormat:@"%lu", (unsigned long)num];
        
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
    
    
    NSString *alertString = @"";
    if ([FBSDKAccessToken currentAccessToken]) {
        alertString = @"Would you like to share to Facebook or Twitter?";
    }else{
        alertString = @"Save workout to your list?";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Great job!" message:alertString delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag = 300;
    [alert show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        if (alertView.tag == 300) {
            if ([FBSDKAccessToken currentAccessToken]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Which one?" message:@"Facebook or Twitter?" delegate:self cancelButtonTitle:@"TWITTER" otherButtonTitles:@"FACEBOOK", nil];
                alert.tag = 301;
                [alert show];
            }else{
                NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
                
                NSFetchRequest *allContacts = [[NSFetchRequest alloc] init];
                [allContacts setEntity:[NSEntityDescription entityForName:@"Workouts" inManagedObjectContext:context]];
                
                Workouts *workouts = [NSEntityDescription insertNewObjectForEntityForName:@"Workouts" inManagedObjectContext:context];
                workouts.userId = [AppDelegate sharedDelegate].sessionId;
                workouts.title = [_beginingArray objectForKey:@"workout"];
                workouts.typeWorkouts = @0;
                workouts.data = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:_beginingArray options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                
                NSError *saveError = nil;
                [context save:&saveError];
                if (saveError) {
                    NSLog(@"Error when saving managed object context : %@", saveError);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }else if (alertView.tag == 301) {//twitter
            NSString *urlAddress = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=Just finished another intense workout on FitShare. Try out %@ on FitShare now!&url=https://www.fitsharingapp.com",[_beginingArray objectForKey:@"workout"]];
            NSString *newString = [urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newString]];
        }
    }else if (buttonIndex == 1) {
        if (alertView.tag == 300) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (alertView.tag == 301) {//facebook
            FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
            content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/fitnectapp/id1146610386?mt=8"];
            content.contentTitle = [NSString stringWithFormat:@"Just finished another intense workout an FitShare. Try out %@ on Fitshare now!", [_beginingArray objectForKey:@"workout"]];
            [FBSDKShareDialog showFromViewController:self
                                         withContent:content
                                            delegate:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[arrBeginingALLExercies objectAtIndex:steps] objectForKey:@"reps"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"RepsItem";
    RepsCell *cell = (RepsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSString *dict = [[[arrBeginingALLExercies objectAtIndex:steps] objectForKey:@"reps"] objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [RepsCell sharedCell];
    }
    [cell setCurWorkoutsItem:dict];
    
    cell.lblNameRep.text = [NSString stringWithFormat:@"Set %ld", (long)indexPath.row+1];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
