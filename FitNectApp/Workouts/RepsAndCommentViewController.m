//
//  RepsAndCommentViewController.m
//  FitNectApp
//
//  Created by stepanekdavid on 11/9/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "RepsAndCommentViewController.h"
#import "RepsEditCell.h"
@interface RepsAndCommentViewController (){
    NSInteger currentSetsCount;
    
    NSMutableArray *tmpComments;
    NSMutableArray *tmpReps;
    
    NSMutableDictionary *editArryWorkouts;
}

@end

@implementation RepsAndCommentViewController
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
    
    tmpComments = [[NSMutableArray alloc] init];
    tmpReps = [[NSMutableArray alloc] init];
    editArryWorkouts = [[NSMutableDictionary alloc] init];
    
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
    
    editArryWorkouts = [[_arrWorkoutsCreated objectForKey:@"data"] mutableCopy];
    lblExercise.text = _exercise;
    currentSetsCount = [_sets integerValue];
    if (!txtComments.focused) {
        txtComments.text = @"Add Comments...";
        [txtComments setTextColor:[UIColor grayColor]];
    }
    if ([AppDelegate sharedDelegate].isSelectedCar == YES) {
        RepsTableview.hidden = YES;
    }else{
        RepsTableview.hidden = NO;
        [RepsTableview reloadData];
    }
    tmpComments = [editArryWorkouts objectForKey:@"comment"];
    tmpReps = [editArryWorkouts objectForKey:@"reps"];
    [self updateTableViewAndViewPosition];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSave:(id)sender {
    if ([AppDelegate sharedDelegate].isSelectedCar == YES){
        for (int i = 0; i < currentSetsCount; i ++) {
            [tmpReps addObject:@"Cardio"];
        }
    }else{
        for (int i=0; i < currentSetsCount; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
            
            UITableViewCell *cell = [RepsTableview cellForRowAtIndexPath:indexPath];
            
            for (UIView *view in  cell.contentView.subviews){
                
                if ([view isKindOfClass:[UITextField class]]){
                    
                    UITextField* txtField = (UITextField *)view;
                    [tmpReps addObject:txtField.text];
                }
            }
        }
    }
    
    if ([txtComments.text isEqualToString:@""] || [txtComments.text isEqualToString:@"Add Comments..."]) {
        [tmpComments addObject:@"No Comments Made"];
    }else{
        [tmpComments addObject:txtComments.text];
    }
    [editArryWorkouts setValue:tmpComments forKey:@"comment"];
    [editArryWorkouts setValue:tmpReps forKey:@"reps"];
    
    NSMutableDictionary *arrSendWorkouts = [[NSMutableDictionary alloc] init];
    [arrSendWorkouts setObject:editArryWorkouts forKey:@"data"];
    [arrSendWorkouts setObject:[_arrWorkoutsCreated objectForKey:@"title"] forKey:@"title"];
    [arrSendWorkouts setObject:[[_arrWorkoutsCreated objectForKey:@"data"] objectForKey:@"goal"] forKey:@"goal"];
    [arrSendWorkouts setObject:[[_arrWorkoutsCreated objectForKey:@"data"] objectForKey:@"workoutname"] forKey:@"workoutname"];
    [arrSendWorkouts setObject:[[_arrWorkoutsCreated objectForKey:@"data"] objectForKey:@"workoutImageUrl"] forKey:@"workoutImageUrl"];
    [AppDelegate sharedDelegate].addOrEditWorkOutsArray = arrSendWorkouts;
    [[AppDelegate sharedDelegate] gotoAddWorkoutsView];
}
- (void)updateTableViewAndViewPosition{
    if ([AppDelegate sharedDelegate].isSelectedCar) {
        [CommentView setFrame:CGRectMake(CommentView.frame.origin.x, RepsTableview.frame.origin.y, CommentView.frame.size.width, CommentView.frame.size.height)];
    }else{
        [RepsTableview setFrame:CGRectMake(RepsTableview.frame.origin.x, RepsTableview.frame.origin.y, RepsTableview.frame.size.width, currentSetsCount * 44)];
        [CommentView setFrame:CGRectMake(CommentView.frame.origin.x, RepsTableview.frame.origin.y + currentSetsCount * 44, CommentView.frame.size.width, CommentView.frame.size.height)];
        if (currentSetsCount > 5) {
            [RepsTableview setFrame:CGRectMake(RepsTableview.frame.origin.x, RepsTableview.frame.origin.y, RepsTableview.frame.size.width, 200)];
            
            [CommentView setFrame:CGRectMake(CommentView.frame.origin.x, RepsTableview.frame.origin.y + 200, CommentView.frame.size.width, CommentView.frame.size.height)];
        }
    }
}
- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return currentSetsCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"RepsEditItem";
    RepsEditCell *cell = [RepsTableview dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [RepsEditCell sharedCell];
    }
    [cell setCurWorkoutsItem:@""];
    cell.txtOneSet.text = @"";
    cell.lblOneSet.text = [NSString stringWithFormat:@"Set %ld", (long)indexPath.row+1];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [txtComments setTextColor:[UIColor blackColor]];
    txtComments.text = @"";
    return YES;
}
@end
