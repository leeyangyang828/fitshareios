//
//  LoginViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/25/15.
//  Copyright © 2015 jella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    BOOL showKeyboard;
    __weak IBOutlet UIImageView *loginImage;
    __weak IBOutlet UIView *seperateView;
    __weak IBOutlet UIButton *signBtn;
    __weak IBOutlet UIButton *loginBtn;
    __weak IBOutlet FBSDKLoginButton *fbLoginBtn;
    __weak IBOutlet FLAnimatedImageView *backgroundImageView;
}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;

- (IBAction)onLogin:(id)sender;
- (IBAction)onNavigateToSignUp:(id)sender;

- (IBAction)onFBLogin:(id)sender;
@end
