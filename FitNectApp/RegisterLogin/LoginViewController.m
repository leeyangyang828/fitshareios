//
//  LoginViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/25/15.
//  Copyright © 2015 jella. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "SelectGYMViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;
@interface LoginViewController ()<FBSDKLoginButtonDelegate>{
    NSMutableArray *allUserInfos;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    showKeyboard = NO;
    
    loginImage.hidden = YES;
    seperateView.hidden = YES;
    _txtEmail.hidden = YES;
    _txtPassword.hidden = YES;
    signBtn.hidden = YES;
    loginBtn.hidden = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [_scrView addGestureRecognizer:gesture];
    fbLoginBtn.delegate = self;
    fbLoginBtn.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    
    NSAttributedString *attrForEmail = [[NSAttributedString alloc] initWithString:@"Email/Username" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    NSAttributedString *attrForPassword = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    _txtEmail.attributedPlaceholder = attrForEmail;
    _txtPassword.attributedPlaceholder = attrForPassword;
    
    
    FLAnimatedImage *bkImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_movie" ofType:@"gif"]]];
    backgroundImageView.animatedImage = bkImage;
    
    
    [AppDelegate sharedDelegate].isFaceBookLogin = NO;
    if ([FBSDKAccessToken currentAccessToken]) {
        [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
        
        // User is logged in, do work such as go to next view controller.
        [[AppDelegate sharedDelegate] loadLoginData];
        [AppDelegate sharedDelegate].isLoginOrRegister = YES;
        [AppDelegate sharedDelegate].isLogin = NO;
        [AppDelegate sharedDelegate].isFaceBookLogin = YES;
        self.navigationItem.title = @"";
        if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
            [[AppDelegate sharedDelegate] goToMainContact];
        }else{
            RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
            [AppDelegate sharedDelegate].isRegister = YES;
            [AppDelegate sharedDelegate].isLogin = NO;
            registerViewController.isFlag = NO;
            //[self presentViewController:loginViewController animated:YES completion:NULL];
            [self.navigationController pushViewController:registerViewController animated:YES];
        }
    }else{
        [self checkSessionID];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    [AppDelegate sharedDelegate].isRegister = NO;
    [AppDelegate sharedDelegate].isLogin = YES;
    [self getUserInfos];
    
}
-(void)checkSessionID{
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"];
    
    if (sessionId) {
        
        [[AppDelegate sharedDelegate] loadLoginData];
        BOOL isCheckUserNameSpell = NO;
        if ([[AppDelegate sharedDelegate].userName containsString:@"."]) {
            isCheckUserNameSpell = YES;
        }else if ([[AppDelegate sharedDelegate].userName containsString:@"#"]){
            isCheckUserNameSpell = YES;
        }else if ([[AppDelegate sharedDelegate].userName containsString:@"$"]){
            isCheckUserNameSpell = YES;
        }else if ([[AppDelegate sharedDelegate].userName containsString:@"["]){
            isCheckUserNameSpell = YES;
        }else if ([[AppDelegate sharedDelegate].userName containsString:@"]"]){
            isCheckUserNameSpell = YES;
        }else if (![AppDelegate sharedDelegate].userName) {
            isCheckUserNameSpell = YES;
        }
        if (!isCheckUserNameSpell) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
            
            [[[rootR child:@"user info"] queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (![AppDelegate sharedDelegate].isRegister && [AppDelegate sharedDelegate].isLogin) {
                    if ([snapshot.key isEqualToString:@"user info"] && ![AppDelegate sharedDelegate].isRegister && [AppDelegate sharedDelegate].isLogin) {
                        NSDictionary *dict = snapshot.value;
                        if (![snapshot.value isKindOfClass:[NSNull class]]) {
                            [[AppDelegate sharedDelegate] loadLoginData];
                            [AppDelegate sharedDelegate].completeNumber =[NSString stringWithFormat:@"%d", 0];
                            [AppDelegate sharedDelegate].sharedNumber =[NSString stringWithFormat:@"%d", 0];
                            
                            for (NSString *snap in dict) {
                                NSDictionary *dictOne = [dict objectForKey:snap];
                                if ([[dictOne objectForKey:@"username"] isEqualToString:[AppDelegate sharedDelegate].userName] && [snap isEqualToString:[AppDelegate sharedDelegate].userName]) {
                                    [AppDelegate sharedDelegate].completeNumber =[NSString stringWithFormat:@"%@", [dictOne objectForKey:@"completeNumber"]];
                                    [AppDelegate sharedDelegate].sharedNumber =[NSString stringWithFormat:@"%@", [dictOne objectForKey:@"sharedNumber"]];
                                }
                            }
                            
                            
                            [AppDelegate sharedDelegate].isLoginOrRegister = YES;
                            [AppDelegate sharedDelegate].isLogin = NO;
                            self.navigationItem.title = @"";
                            [[AppDelegate sharedDelegate] saveLoginData];
                            if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
                                [[AppDelegate sharedDelegate] goToMainContact];
                            }else{
                                RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
                                [AppDelegate sharedDelegate].isRegister = YES;
                                [AppDelegate sharedDelegate].isLogin = NO;
                                registerViewController.isFlag = NO;
                                //[self presentViewController:loginViewController animated:YES completion:NULL];
                                [self.navigationController pushViewController:registerViewController animated:YES];
                            }
                            return;
                        }
                            loginImage.hidden = NO;
                            seperateView.hidden = NO;
                            _txtEmail.hidden = NO;
                            _txtPassword.hidden = NO;
                            signBtn.hidden = NO;
                            loginBtn.hidden = NO;
                            [[AppDelegate sharedDelegate] deleteLoginData];
                        
                    }
                }
                
            }
                                                             withCancelBlock:^(NSError *error){
                                                                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                 
                                                                 loginImage.hidden = NO;
                                                                 seperateView.hidden = NO;
                                                                 _txtEmail.hidden = NO;
                                                                 _txtPassword.hidden = NO;
                                                                 signBtn.hidden = NO;
                                                                 loginBtn.hidden = NO;
                                                                 NSLog(@"%@", error.description);
                                                             }];
        }else{
            loginImage.hidden = NO;
            seperateView.hidden = NO;
            _txtEmail.hidden = NO;
            _txtPassword.hidden = NO;
            signBtn.hidden = NO;
            loginBtn.hidden = NO;
            [[AppDelegate sharedDelegate] deleteLoginData];
        }
        
    } else {
        loginImage.hidden = NO;
        seperateView.hidden = NO;
        _txtEmail.hidden = NO;
        _txtPassword.hidden = NO;
        signBtn.hidden = NO;
        loginBtn.hidden = NO;
        [[AppDelegate sharedDelegate] deleteLoginData];
    }

}
- (void)getUserInfos{
    allUserInfos = [[NSMutableArray alloc] init];
    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
    
    [[[rootR child:@"user info"] queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        if ([snapshot.key isEqualToString:@"user info"]) {
            [allUserInfos removeAllObjects];
            if (![snapshot.value isKindOfClass:[NSNull class]]) {
                allUserInfos = [snapshot.value mutableCopy];
            }
        }
    }
    withCancelBlock:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@", error.description);
    }];
}
-(void)handleTap
{
        [self.view endEditing:YES];
        [_scrView setContentSize:CGSizeMake(0, 0)];
}
- (void)keyboardWasShown:(NSNotification*)aNotification {
    if (!showKeyboard)
    {
        showKeyboard = YES;
        [_scrView setContentSize:CGSizeMake(320, _scrView.frame.size.height + 116.0f)];
        if (IS_IPHONE_5) {
            [_scrView setContentOffset:CGPointMake(0, 110) animated:YES];
        } else [_scrView setContentOffset:CGPointMake(0, 160) animated:YES];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        [_scrView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}
- (IBAction)onLogin:(id)sender {
    [self.view endEditing:YES];
    if (!_txtEmail.text.length)
    {
        [self showAlert:@"Please input your Email Address or username" :@"Input Error" :nil];
        return;
    }
    if ([_txtEmail.text rangeOfString:@"@"].length != 0) {
        if ([_txtEmail.text rangeOfString:@" "].length != 0) {
            [self showAlert:@"Email field contains space. Please input again" :@"Input Error" :nil];
            return;
        }
        if (![self checkEmail:_txtEmail]) {
            return;
        }
    }
    if (_txtPassword.text.length < 6)
    {
        [self showAlert:@"Password should have at least 6 characters" :@"Input Error" :nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FIRAuth auth] signInWithEmail:_txtEmail.text password:_txtPassword.text completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (error) {
            NSLog(@"Firebase Register failed : %@", error);
            NSDictionary * errorDic = error.userInfo;
            [self showAlert:[errorDic objectForKey:@"NSLocalizedDescription"] :@"Oops!" :nil];
            return ;
        }else{
            [AppDelegate sharedDelegate].isLoginOrRegister = NO;
            [AppDelegate sharedDelegate].sessionId = user.uid;
            [AppDelegate sharedDelegate].userEmail = user.email;
            [AppDelegate sharedDelegate].completeNumber =[NSString stringWithFormat:@"%d", 0];
            [AppDelegate sharedDelegate].sharedNumber =[NSString stringWithFormat:@"%d", 0];
            for (NSString *snap in allUserInfos) {
                NSMutableDictionary *dict = [allUserInfos copy];
                NSDictionary *dictOne = [dict objectForKey:snap];
                    
                if ([user.email isEqualToString:[dictOne objectForKey:@"email"]]) {
                    [AppDelegate sharedDelegate].userName = [dictOne objectForKey:@"username"];
                    [AppDelegate sharedDelegate].userFirstName = [dictOne objectForKey:@"firstName"];
                    [AppDelegate sharedDelegate].userLastName = [dictOne objectForKey:@"lastName"];
                    if ([dictOne objectForKey:@"profileUrl"]) {
                        [AppDelegate sharedDelegate].curUserProfileImageUrl = [dictOne objectForKey:@"profileUrl"];
                    }else{
                        [AppDelegate sharedDelegate].curUserProfileImageUrl = @"";
                    }
                    if ([[dictOne objectForKey:@"username"] isEqualToString:snap]) {
                        [AppDelegate sharedDelegate].completeNumber =[NSString stringWithFormat:@"%@", [dictOne objectForKey:@"completeNumber"]];
                        [AppDelegate sharedDelegate].sharedNumber =[NSString stringWithFormat:@"%@", [dictOne objectForKey:@"sharedNumber"]];
                    }
                    if ([dictOne objectForKey:@"goal"]) {
                        [AppDelegate sharedDelegate].goal = [dictOne objectForKey:@"goal"];
                    }
                    if ([dictOne objectForKey:@"gym"]) {
                        [AppDelegate sharedDelegate].currentGym = [dictOne objectForKey:@"gym"];
                    }
                }
            }
            NSLog(@"username -%@", [AppDelegate sharedDelegate].userName);
            [AppDelegate sharedDelegate].aboutMe = @"";
            [AppDelegate sharedDelegate].isLogin = NO;
            if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
                [[AppDelegate sharedDelegate] gotToGYMSelected];
            }else{
                RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
                [AppDelegate sharedDelegate].isRegister = YES;
                [AppDelegate sharedDelegate].isLogin = NO;
                //[self presentViewController:loginViewController animated:YES completion:NULL];
                registerViewController.isFlag = YES;
                [self.navigationController pushViewController:registerViewController animated:YES];
            }
        }
    }];
    
}

- (IBAction)onNavigateToSignUp:(id)sender {
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    [AppDelegate sharedDelegate].isRegister = YES;
    [AppDelegate sharedDelegate].isLogin = NO;
    //[self presentViewController:loginViewController animated:YES completion:NULL];
    registerViewController.isFlag = NO;
    [self.navigationController pushViewController:registerViewController animated:YES];
    
}
#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[_scrView setContentSize:CGSizeMake(320, _scrView.frame.size.height + 116.0f)];
//    if (IS_IPHONE_5) {
//        [_scrView setContentOffset:CGPointMake(0, 110) animated:YES];
//    } else [_scrView setContentOffset:CGPointMake(0, 160) animated:YES];
    
    if (textField == _txtEmail)
    {
        [_txtPassword becomeFirstResponder];
    } else {
        [self onLogin:nil];
    }
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    [_scrView setContentSize:CGSizeMake(320, _scrView.frame.size.height + 116.0f)];
//    if (IS_IPHONE_5) {
//        [_scrView setContentOffset:CGPointMake(0, 110) animated:YES];
//    } else [_scrView setContentOffset:CGPointMake(0, 160) animated:YES];
//    return YES;
//}
- (BOOL)checkEmail:(UITextField *)checkText
{
    BOOL filter = YES ;
    NSString *filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = filter ? filterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if([emailTest evaluateWithObject:checkText.text] == NO)
    {
        [self showAlert:@"PError" :@"Please enter a valid email address." :nil];
        return NO ;
    }
    
    return YES ;
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height >= 568.0);
}
#pragma mark - Facebook Delegate
- (void)  loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    
    [AppDelegate sharedDelegate].isFaceBookLogin = YES;
    if (error != nil) {
        
        [AppDelegate sharedDelegate].isFaceBookLogin = NO;
        NSLog(@"");
        return;
    }
    [AppDelegate sharedDelegate].isFaceBookLogin = YES;
    loginImage.hidden = YES;
    seperateView.hidden = YES;
    _txtEmail.hidden = YES;
    _txtPassword.hidden = YES;
    signBtn.hidden = YES;
    loginBtn.hidden = YES;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture, email, name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             
             [AppDelegate sharedDelegate].isFaceBookLogin = YES;
             [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
             FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
             
             [[rootR queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 if (![AppDelegate sharedDelegate].isRegister && [AppDelegate sharedDelegate].isLogin) {
                     NSDictionary *dict = snapshot.value;
                     BOOL isFind = NO;
                     for (NSString *username in [dict objectForKey:@"user info"]) {
                         
                         NSDictionary *dictOne = [[dict objectForKey:@"user info"] objectForKey:username];
                         
                         if ([[dictOne objectForKey:@"email"] isEqualToString:[result objectForKey:@"email"]]) {
                             NSLog(@"%@", dictOne);
                             isFind = YES;
                             if ([dictOne objectForKey:@"completeNumber"]) {
                                 [AppDelegate sharedDelegate].completeNumber = [dictOne objectForKey:@"completeNumber"];
                             }else{
                                 [AppDelegate sharedDelegate].completeNumber = @"0";
                             }
                             if ([dictOne objectForKey:@"sharedNumber"]) {
                                 [AppDelegate sharedDelegate].sharedNumber = [dictOne objectForKey:@"sharedNumber"];
                             }else{
                                 [AppDelegate sharedDelegate].sharedNumber = @"0";
                             }
                             [AppDelegate sharedDelegate].sessionId = [result objectForKey:@"id"];
                             [AppDelegate sharedDelegate].userEmail = [result objectForKey:@"email"];
                             [AppDelegate sharedDelegate].userName = [dictOne objectForKey:@"username"];
                             [AppDelegate sharedDelegate].userFirstName = [dictOne objectForKey:@"firstName"];
                             [AppDelegate sharedDelegate].userLastName = [dictOne objectForKey:@"lastName"];
                             [AppDelegate sharedDelegate].curUserProfileImageUrl = [dictOne objectForKey:@"profileUrl"];
                             [AppDelegate sharedDelegate].aboutMe = [dictOne objectForKey:@"aboutMe"]?[dictOne objectForKey:@"aboutMe"]:@"";
                             [AppDelegate sharedDelegate].goal = [dictOne objectForKey:@"goal"]?[dictOne objectForKey:@"goal"]:@"";
                             [AppDelegate sharedDelegate].currentGym = [dictOne objectForKey:@"gym"];
                             [AppDelegate sharedDelegate].isLogin = NO;
                             [[AppDelegate sharedDelegate] saveLoginData];
                             if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
                                 [[AppDelegate sharedDelegate] gotToGYMSelected];
                             }else{
                                 RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
                                 [AppDelegate sharedDelegate].isRegister = YES;
                                 [AppDelegate sharedDelegate].isLogin = NO;
                                 //[self presentViewController:loginViewController animated:YES completion:NULL];
                                 registerViewController.isFlag = YES;
                                 [self.navigationController pushViewController:registerViewController animated:YES];
                             }
                             return;
                         }
                     }
                     
                     if (!isFind) {
                         [AppDelegate sharedDelegate].completeNumber = @"0";
                         [AppDelegate sharedDelegate].sharedNumber = @"0";
                         [AppDelegate sharedDelegate].sessionId = [result objectForKey:@"id"];
                         [AppDelegate sharedDelegate].userEmail = [result objectForKey:@"email"];
                         [AppDelegate sharedDelegate].userName = [result objectForKey:@"name"];
                         NSString *userFName;
                         NSString *userLName;
                         if ([[result objectForKey:@"name"] rangeOfString:@" "].location != NSNotFound)
                         {
                             userFName = [[result objectForKey:@"name"] substringToIndex:[[result objectForKey:@"name"] rangeOfString:@" "].location];
                             userLName = [[result objectForKey:@"name"] substringFromIndex:[[result objectForKey:@"name"] rangeOfString:@" "].location + 1];
                         }else{
                             userFName = [result objectForKey:@"name"];
                             userLName = @"";
                         }
                         [AppDelegate sharedDelegate].userFirstName = userFName;
                         [AppDelegate sharedDelegate].userLastName = userLName;
                         [AppDelegate sharedDelegate].curUserProfileImageUrl = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                         [[AppDelegate sharedDelegate] saveLoginData];
                         [AppDelegate sharedDelegate].isLogin = NO;
                         RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
                         [AppDelegate sharedDelegate].isRegister = YES;
                         [AppDelegate sharedDelegate].isLogin = NO;
                         registerViewController.isFlag = NO;
                         //[self presentViewController:loginViewController animated:YES completion:NULL];
                         [self.navigationController pushViewController:registerViewController animated:YES];
                         return;
                     }
                 }
                 
             }
            withCancelBlock:^(NSError *error){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSLog(@"%@", error.description);
            }];
         }
         else{
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             NSLog(@"%@", [error localizedDescription]);
             
             [AppDelegate sharedDelegate].isFaceBookLogin = NO;
         }
     }];
}
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{

}

- (IBAction)onFBLogin:(id)sender {
}
@end
