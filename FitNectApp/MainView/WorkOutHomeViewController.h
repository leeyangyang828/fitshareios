//
//  WorkOutHomeViewController.h
//  FitNectApp
//
//  Created by stepanekdavid on 12/12/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOutHomeViewController : UIViewController{
    
    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UIView *welcomeView;
    __weak IBOutlet UIButton *shownCheckBtn;
}
@property (strong, nonatomic) IBOutlet UIView *navView;
- (IBAction)onMyWorkouts:(id)sender;

- (IBAction)onStrengthTraing:(id)sender;
- (IBAction)onCardioTraining:(id)sender;
- (IBAction)onTrainerWorkouts:(id)sender;
- (IBAction)onFitShareFeatured:(id)sender;

- (IBAction)onNotification:(id)sender;
- (IBAction)onMenu:(id)sender;

- (IBAction)onStart:(id)sender;
- (IBAction)onCheckShown:(id)sender;
@end
