//
//  FirstpageForAddingWorkoutViewController.h
//  FitNectApp
//
//  Created by stepanekdavid on 12/12/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstpageForAddingWorkoutViewController : UIViewController{

    IBOutlet UIView *navView;
    __weak IBOutlet UITextField *txtWorkoutName;
    __weak IBOutlet UIButton *typeWorkouts;
    __weak IBOutlet UITableView *WorkoutTypeTableview;
    __weak IBOutlet UIButton *btnWorkourtProfileImage;
}

- (IBAction)onBack:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onWorkoutType:(id)sender;

- (IBAction)onUseProfile:(id)sender;
- (IBAction)onLoadWorkoutImage:(id)sender;

- (IBAction)onStartAddingExercises:(id)sender;
@end
