//
//  BeginWorkoutsViewController.h
//  FitNectApp
//
//  Created by stepanekdavid on 8/23/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeginWorkoutsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *beginUserName;

@property (weak, nonatomic) IBOutlet UILabel *beginExerciese;
@property (weak, nonatomic) IBOutlet UITextView *beginComment;

@property (weak, nonatomic) IBOutlet UITableView *RepsTableview;

@property (strong, nonatomic) NSMutableDictionary *beginingArray;
- (IBAction)onLookTutorial:(id)sender;

- (IBAction)onBackStep:(id)sender;
- (IBAction)onNextSteps:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBackSteps;
@property (weak, nonatomic) IBOutlet UIButton *btnNextSteps;



@end
