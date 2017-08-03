//
//  OneWorkouksCurrentUserViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/27/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import "OneWorkouksCurrentUserViewController.h"
#import "WorkOutsCell.h"
#import "AppDelegate.h"
@interface OneWorkouksCurrentUserViewController (){
    
    NSMutableArray *arrALLExercies;
}

@end

@implementation OneWorkouksCurrentUserViewController
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
    arrALLExercies = [[NSMutableArray alloc] init];
    
    noteView.hidden = YES;
    
    NSMutableDictionary *dict = [_infoSelectedWorkOuts objectForKey:@"data"];
    NSString *strExercies = [[[[dict objectForKey:@"exercise"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strSets = [[[[dict objectForKey:@"sets"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strReps = [[[[dict objectForKey:@"reps"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray *arrExercies = [strExercies componentsSeparatedByString:@","];
    NSArray *arrSets = [strSets componentsSeparatedByString:@","];
    NSArray *arrReps = [strReps componentsSeparatedByString:@","];
    //NSLog(@"%@", arrExercies);
    for (int i = 0; i < arrExercies.count; i ++) {
        NSMutableDictionary *oneExerices = [[NSMutableDictionary alloc] init];
        [oneExerices setValue:arrExercies[i] forKey:@"exercies"];
        [oneExerices setValue:arrReps[i] forKey:@"reps"];
        [oneExerices setValue:arrSets[i] forKey:@"sets"];
        
        [arrALLExercies addObject:oneExerices];
    }
    lblWorkoutsName.text = [_infoSelectedWorkOuts objectForKey:@"workoutsId"];
    
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
    
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fitlove"] style:UIBarButtonItemStylePlain target:self action:@selector(onFaveriteClick:)];
    UIBarButtonItem *barButton2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"note"] style:UIBarButtonItemStylePlain target:self action:@selector(onNoteClick:)];
    self.navigationItem.rightBarButtonItems = @[barButton2, barButton1];
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
    return [arrALLExercies count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"WorkoutCell";
    WorkOutsCell *cell = [workoutsFromFireBaseTableview dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict = [arrALLExercies objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [WorkOutsCell sharedCell];
    }
    
    cell.resDelegate = self;
    
    //NSLog(@"DATE--------%@",[lstDate objectAtIndex:indexPath.row]);
    [cell setCurWorkoutsItem:dict];
    
    [cell.txtExercise setText:[dict objectForKey:@"exercies"]];
    [cell.txtReps setText:[dict objectForKey:@"reps"]];
    [cell.txtSets setText:[dict objectForKey:@"sets"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)onFaveriteClick:(id)sender {
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNoteClick:(id)sender {
    noteView.hidden = NO;
}
- (IBAction)onCloseClick:(id)sender {
    noteView.hidden = YES;
}

- (void)didComments:(NSString *)workoutsDict{
    noteView.hidden = NO;
    _lblComments.text = workoutsDict;
}
@end
