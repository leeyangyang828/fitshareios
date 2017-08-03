//
//  MainViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/25/15.
//  Copyright © 2015 jella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController{
}
+ (MainViewController *)sharedController;
- (void)showTabbarImage:(BOOL)show;

@end
