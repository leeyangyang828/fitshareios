//
//  ProfileViewController.h
//  FitNectApp
//
//  Created by stepanekdavid on 8/23/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController{
    
    __weak IBOutlet UILabel *lblAboutMeAndGoal;
}

@property (weak, nonatomic) IBOutlet UIImageView *selectedUserProfileImageview;
@property (weak, nonatomic) IBOutlet UILabel *lblFouseUserName;
@property (weak, nonatomic) IBOutlet UILabel *numCompletedFouseUser;
@property (weak, nonatomic) IBOutlet UILabel *numSharedFouseUser;

@property (strong, nonatomic) NSString *selectedUserNameForWorkouts;
@property (weak, nonatomic) IBOutlet UITableView *fouseUserWorksTableview;

@property (weak, nonatomic) IBOutlet UILabel *trainerLevel;
@end
