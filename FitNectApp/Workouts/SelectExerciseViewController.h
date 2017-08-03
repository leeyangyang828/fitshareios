//
//  SelectExerciseViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/28/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectExerciseViewControllerDelegate

@optional;
- (void)getExercise:(NSString *)selectedExercise;
@end

@interface SelectExerciseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    __weak IBOutlet UIButton *btnMachines;
    __weak IBOutlet UIButton *btnFreeWeight;
    __weak IBOutlet UITableView *exerciesListTableView;
    __weak IBOutlet UIView *tabBtnsView;
}
@property (weak, nonatomic) id<SelectExerciseViewControllerDelegate> exerciseDelegate;
- (IBAction)onCloseClick:(id)sender;
- (IBAction)onFreeWeightClick:(id)sender;
- (IBAction)onMachinesClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabButtonWidth;
@property  NSInteger indexSelectedExercies;

@end
