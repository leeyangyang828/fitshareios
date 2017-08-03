//
//  SelectExerciseViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/28/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import "SelectExerciseViewController.h"
#import "AppDelegate.h"
#import "ExerciseCell.h"

@interface SelectExerciseViewController ()<ExerciseCellDelegate>{
    BOOL isSelectedFree;
    NSArray *fwArray;
    NSArray *mcnArray;
}

@end


@implementation SelectExerciseViewController
@synthesize indexSelectedExercies;
- (void)viewDidLoad {
    [super viewDidLoad];
    isSelectedFree = YES;
    btnFreeWeight.backgroundColor = [UIColor colorWithRed:121.0f/255.0f green:134.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    NSLog(@"%ld", (long)indexSelectedExercies);
//    
//    fwArray = [[NSMutableArray alloc] init];
//    mcnArray = [[NSMutableArray alloc] init];
    
    switch (indexSelectedExercies) {
        case 1:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"abs_fw" ofType:@"rtf"];
            NSString *strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            fwArray = [strFromFile componentsSeparatedByString:@","];
            path = [[NSBundle mainBundle] pathForResource:@"abs_mcn" ofType:@"rtf"];
            strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            mcnArray = [strFromFile componentsSeparatedByString:@","];
            [AppDelegate sharedDelegate].isSelectedCar = NO;
        }
            break;
        case 2:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"back_fw" ofType:@"rtf"];
            NSString *strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            fwArray = [strFromFile componentsSeparatedByString:@","];
            path = [[NSBundle mainBundle] pathForResource:@"back_mcn" ofType:@"rtf"];
            strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            mcnArray = [strFromFile componentsSeparatedByString:@","];
            [AppDelegate sharedDelegate].isSelectedCar = NO;
        }
            break;
        case 3:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"biceps_fw" ofType:@"rtf"];
            NSString *strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            fwArray = [strFromFile componentsSeparatedByString:@","];
            path = [[NSBundle mainBundle] pathForResource:@"biceps_mcn" ofType:@"rtf"];
            strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            mcnArray = [strFromFile componentsSeparatedByString:@","];
            [AppDelegate sharedDelegate].isSelectedCar = NO;
        }
            break;
        case 4:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"cardio_fw" ofType:@"rtf"];
            NSString *strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            fwArray = [strFromFile componentsSeparatedByString:@","];
            path = [[NSBundle mainBundle] pathForResource:@"cardio_mcn" ofType:@"rtf"];
            strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            mcnArray = [strFromFile componentsSeparatedByString:@","];
            [AppDelegate sharedDelegate].isSelectedCar = YES;
        }
            break;
        case 5:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"chest_fw" ofType:@"rtf"];
            NSString *strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            fwArray = [strFromFile componentsSeparatedByString:@","];
            path = [[NSBundle mainBundle] pathForResource:@"chest_mcn" ofType:@"rtf"];
            strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            mcnArray = [strFromFile componentsSeparatedByString:@","];
            [AppDelegate sharedDelegate].isSelectedCar = NO;
        }
            break;
        case 6:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"legs_fw" ofType:@"rtf"];
            NSString *strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            fwArray = [strFromFile componentsSeparatedByString:@","];
            path = [[NSBundle mainBundle] pathForResource:@"legs_mcn" ofType:@"rtf"];
            strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            mcnArray = [strFromFile componentsSeparatedByString:@","];
            [AppDelegate sharedDelegate].isSelectedCar = NO;
        }
            break;
        case 7:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"shoulders_fw" ofType:@"rtf"];
            NSString *strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            fwArray = [strFromFile componentsSeparatedByString:@","];
            path = [[NSBundle mainBundle] pathForResource:@"shoulders_mcn" ofType:@"rtf"];
            strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            mcnArray = [strFromFile componentsSeparatedByString:@","];
            [AppDelegate sharedDelegate].isSelectedCar = NO;
        }
            break;
        case 8:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"triceps_fw" ofType:@"rtf"];
            NSString *strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            fwArray = [strFromFile componentsSeparatedByString:@","];
            path = [[NSBundle mainBundle] pathForResource:@"triceps_mcn" ofType:@"rtf"];
            strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            mcnArray = [strFromFile componentsSeparatedByString:@","];
            [AppDelegate sharedDelegate].isSelectedCar = NO;
        }
            break;
        case 9:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"abs_fw" ofType:@"rtf"];
            NSString *strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            fwArray = [strFromFile componentsSeparatedByString:@","];
            path = [[NSBundle mainBundle] pathForResource:@"abs_mcn" ofType:@"rtf"];
            strFromFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            mcnArray = [strFromFile componentsSeparatedByString:@","];
        }
            break;
        default:
            break;
    }
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tabButtonWidth.constant = [[UIScreen mainScreen] bounds].size.width/2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onFreeWeightClick:(id)sender {
    btnFreeWeight.backgroundColor = [UIColor colorWithRed:121.0f/255.0f green:134.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    btnMachines.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    isSelectedFree = YES;
    [exerciesListTableView reloadData];
}

- (IBAction)onMachinesClick:(id)sender {
    btnFreeWeight.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    btnMachines.backgroundColor = [UIColor colorWithRed:121.0f/255.0f green:134.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    isSelectedFree = NO;
    [exerciesListTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isSelectedFree) {
        return fwArray.count;
    }else{
        return mcnArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *sortTableViewIdentifier = @"ExerciseItem";
    ExerciseCell *cell = [exerciesListTableView dequeueReusableCellWithIdentifier:sortTableViewIdentifier];
    if (cell == nil) {
        cell = [ExerciseCell sharedCell];
    }
     [cell setDelegate:self];
    if (isSelectedFree) {
        cell.helpExerciseName.text =[fwArray objectAtIndex:indexPath.row];
        [cell setItem:[fwArray objectAtIndex:indexPath.row]];
    }else{
        cell.helpExerciseName.text = [mcnArray objectAtIndex:indexPath.row];
        [cell setItem:[mcnArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isSelectedFree) {
        [AppDelegate sharedDelegate].currentHelpforExercies = [fwArray objectAtIndex:indexPath.row];
        [_exerciseDelegate getExercise:[fwArray objectAtIndex:indexPath.row]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [AppDelegate sharedDelegate].currentHelpforExercies = [mcnArray objectAtIndex:indexPath.row];
        [_exerciseDelegate getExercise:[mcnArray objectAtIndex:indexPath.row]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)searchHelping:(NSString *)exercieName{
    
    NSString *urlAddress = [NSString stringWithFormat:@"http://www.google.com/search?q=%@+Tutorial",[[exercieName stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByReplacingOccurrencesOfString:@"\n" withString:@"+"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddress]];
}
@end
