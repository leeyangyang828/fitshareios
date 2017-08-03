//
//  RegisterViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/25/15.
//  Copyright © 2015 jella. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "SelectGYMViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Resize.h"

@import Firebase;
@import FirebaseStorage;

@interface RegisterViewController (){
    BOOL isRegisted;
    BOOL isCheckUser;
    UIImage *profileImg;
    
    NSMutableArray *userNames;
}

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    showKeyboard = NO;
    userNames = [[NSMutableArray alloc] init];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [scrView addGestureRecognizer:gesture];
    
    isRegisted = NO;
    isCheckUser = NO;
    userProfileBut.imageView.contentMode = UIViewContentModeScaleAspectFill;
    userProfileBut.clipsToBounds = YES;
    userProfileBut.layer.cornerRadius = CGRectGetWidth(userProfileBut.frame) / 2;
    [self setupUI];
    
    if ([AppDelegate sharedDelegate].isFaceBookLogin || _isFlag) {
        lblPassword1.hidden = YES;
        lblPassword2.hidden = YES;
        _txtpassword.hidden = YES;
        _txtConfirmPassword.hidden = YES;
        _txtFirstName.text = [AppDelegate sharedDelegate].userFirstName;
        _txtLastName.text = [AppDelegate sharedDelegate].userLastName;
        _txtEmail.text = [AppDelegate sharedDelegate].userEmail;
    }else{
        lblPassword1.hidden = NO;
        lblPassword2.hidden = NO;
        _txtpassword.hidden = NO;
        _txtConfirmPassword.hidden = NO;
    }
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)setupUI{
    [self.navigationItem setTitle:@"Register"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *btRegister;
    btRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [btRegister setFrame:CGRectMake(0,0,60,30)];
    [btRegister setTitle:@"Signup" forState:UIControlStateNormal];
    [btRegister setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btRegister addTarget:self action:@selector(onRegisterClick:) forControlEvents:UIControlEventTouchUpInside];
    [btRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *btBarRegister = [[UIBarButtonItem alloc] initWithCustomView:btRegister];
    [self.navigationItem setRightBarButtonItem:btBarRegister];
    
    
}
- (void)keyboardWasShown:(NSNotification*)aNotification {
    if (!showKeyboard)
    {
        showKeyboard = YES;
        [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
        if (IS_IPHONE_5) {
            [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
        } else [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        [scrView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
    if (IS_IPHONE_5) {
        [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if (textField == self.txtFirstName) {
        [self.txtLastName becomeFirstResponder];
        if (IS_IPHONE_5) {
            [scrView setContentOffset:CGPointMake(0, 30) animated:YES];
        } else [scrView setContentOffset:CGPointMake(0, 40) animated:YES];
    }
    else if (textField == self.txtLastName){
        [self.txtEmail becomeFirstResponder];
        if (IS_IPHONE_5) {
            [scrView setContentOffset:CGPointMake(0, 60) animated:YES];
        } else [scrView setContentOffset:CGPointMake(0, 80) animated:YES];
    }
    else if (textField == self.txtEmail){
        [self.txtUsername becomeFirstResponder];
        if (IS_IPHONE_5) {
            [scrView setContentOffset:CGPointMake(0, 90) animated:YES];
        } else [scrView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
    else if (textField == self.txtUsername){
        
        [self onRegisterClick:nil];
//        [self.txtpassword becomeFirstResponder];
//        if (IS_IPHONE_5) {
//            [scrView setContentOffset:CGPointMake(0, 120) animated:YES];
//        } else [scrView setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    else if (textField == self.txtpassword){
        [self.txtConfirmPassword becomeFirstResponder];
        if (IS_IPHONE_5) {
            [scrView setContentOffset:CGPointMake(0, 150) animated:YES];
        } else [scrView setContentOffset:CGPointMake(0, 170) animated:YES];
    }else {
        [self onRegisterClick:nil];
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [scrView setContentSize:CGSizeMake(320, scrView.frame.size.height)];
    if (IS_IPHONE_5) {
        [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else [scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    if (textField == self.txtLastName) {
        if (IS_IPHONE_5) {
            [scrView setContentOffset:CGPointMake(0, 30) animated:YES];
        } else [scrView setContentOffset:CGPointMake(0, 40) animated:YES];
    }
    else if (textField == self.txtEmail){
        if (IS_IPHONE_5) {
            [scrView setContentOffset:CGPointMake(0, 60) animated:YES];
        } else [scrView setContentOffset:CGPointMake(0, 80) animated:YES];
    }
    else if (textField == self.txtUsername){
        if (IS_IPHONE_5) {
            [scrView setContentOffset:CGPointMake(0, 90) animated:YES];
        } else [scrView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
    else if (textField == self.txtpassword){
        if (IS_IPHONE_5) {
            [scrView setContentOffset:CGPointMake(0, 120) animated:YES];
        } else [scrView setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    else if (textField == self.txtConfirmPassword){
        if (IS_IPHONE_5) {
            [scrView setContentOffset:CGPointMake(0, 150) animated:YES];
        } else [scrView setContentOffset:CGPointMake(0, 170) animated:YES];
    }
}
-(void)handleTap
{
    if (showKeyboard)
    {
        [self.view endEditing:YES];
        [scrView setContentSize:CGSizeMake(0, 0)];
        showKeyboard = NO;
    }
}
- (IBAction)onRegisterClick:(id)sender {
    if (!_txtFirstName.text.length || !_txtLastName.text.length)
    {
        [self showAlert:@"Please input Name" :@"Input Error" :nil];
        return;
    }
    if (!_txtEmail.text.length)
    {
        [self showAlert:@"Please input your Email Address" :@"Input Error" :nil];
        return;
    }
    if ([_txtEmail.text rangeOfString:@" "].length != 0) {
        [self showAlert:@"Email field contains space. Please input again" :@"Input Error" :nil];
        return;
    }
    if (![self checkEmail:_txtEmail]) {
        return;
    }
    if (!_txtUsername.text.length)
    {
        [self showAlert:@"Please input User Name" :@"Input Error" :nil];
        return;
    }
    if ([userNames containsObject:_txtUsername.text]) {
        
        [self showAlert:@"Username already exists!" :@"Input Error" :nil];
        return;
    }
    if ([_txtUsername.text containsString:@"."]) {
        [self showAlert:@"Username must be a non-empty string and not contain '.', '#' ,'$' ,'[' or ']'" :@"Input Error" :nil];
        return;
    }else if ([_txtUsername.text containsString:@"#"]){
        
        [self showAlert:@"Username must be a non-empty string and not contain '.', '#', '$', '[' or ']'" :@"Input Error" :nil];
        return;
    }else if ([_txtUsername.text containsString:@"$"]){
        
        [self showAlert:@"Username must be a non-empty string and not contain '.', '#', '$', '[' or ']'" :@"Input Error" :nil];
        return;
    }else if ([_txtUsername.text containsString:@"["]){
        
        [self showAlert:@"Username must be a non-empty string and not contain '.', '#', '$', '[' or ']'" :@"Input Error" :nil];
        return;
    }else if ([_txtUsername.text containsString:@"]"]){
        
        [self showAlert:@"Username must be a non-empty string and not contain '.', '#', '$', '[' or ']'" :@"Input Error" :nil];
        return;
    }
    if ([AppDelegate sharedDelegate].isFaceBookLogin || _isFlag) {
        
    }else{
        if (_txtpassword.text.length < 6)
        {
            [self showAlert:@"Password should have at least 6 characters" :@"Input Error" :nil];
            return;
        }
        
        if (![_txtpassword.text isEqualToString:_txtConfirmPassword.text])
        {
            [self showAlert:@"Passwords don't match!" :@"Oops!" :nil];
            return;
        }

    }
    
    [self.view endEditing:YES];
    
    if ([AppDelegate sharedDelegate].isFaceBookLogin || _isFlag) {
        
        [AppDelegate sharedDelegate].userName = _txtUsername.text;
        [AppDelegate sharedDelegate].aboutMe = @"";
        [AppDelegate sharedDelegate].goal = @"";
        [AppDelegate sharedDelegate].currentGym = @"";
        
        [[AppDelegate sharedDelegate] saveLoginData];
//        NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
//        [userInfoForPost setValue:[AppDelegate sharedDelegate].userEmail forKey:@"email"];
//        [userInfoForPost setValue:[AppDelegate sharedDelegate].userFirstName forKey:@"firstName"];
//        [userInfoForPost setValue:[AppDelegate sharedDelegate].userLastName forKey:@"lastName"];
//        [userInfoForPost setValue:[AppDelegate sharedDelegate].userName forKey:@"username"];
//        [userInfoForPost setValue:[AppDelegate sharedDelegate].curUserProfileImageUrl forKey:@"profileUrl"];
//        [userInfoForPost setValue:[AppDelegate sharedDelegate].completeNumber forKey:@"completeNumber"];
//        [userInfoForPost setValue:[AppDelegate sharedDelegate].sharedNumber forKey:@"sharedNumber"];
//        [userInfoForPost setValue:[AppDelegate sharedDelegate].goal forKey:@"goal"];
//        [userInfoForPost setValue:[AppDelegate sharedDelegate].currentGym forKey:@"gym"];
//        [userInfoForPost setValue:[AppDelegate sharedDelegate].aboutMe forKey:@"aboutMe"];
//        if ([AppDelegate sharedDelegate].userName) {
//        FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
//        FIRDatabaseReference *rootRForResgiter = [[rootR child:@"user info"] child:[AppDelegate sharedDelegate].userName];
//        [rootRForResgiter setValue:userInfoForPost];
//        }
        
        [[AppDelegate sharedDelegate] gotToGYMSelected];
    }else{
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[FIRAuth auth] createUserWithEmail:_txtEmail.text password:_txtpassword.text completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
            
            if (error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSLog(@"Firebase Register failed : %@", error);
                NSDictionary * errorDic = error.userInfo;
                [self showAlert:[errorDic objectForKey:@"NSLocalizedDescription"] :@"Oops!" :nil];
            }else{
                if (profileImg ) {
                    FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:@"gs://fitnectapp.appspot.com"];
                    NSData *imageData = UIImageJPEGRepresentation(profileImg, 0.8);
                    NSString *imagePath = [NSString stringWithFormat:@"profile/%@_%lld.jpg",[FIRAuth auth].currentUser.uid,
                                           (long long)([[NSDate date] timeIntervalSince1970] * 1000.0)];
                    FIRStorageMetadata *metadata = [FIRStorageMetadata new];
                    metadata.contentType = @"image/jpeg";
                    [[storageRef child:imagePath] putData:imageData metadata:metadata completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        if (error) {
                            NSLog(@"Error uploading: %@", error);
                            NSDictionary * errorDic = error.userInfo;
                            [self showAlert:[errorDic objectForKey:@"NSLocalizedDescription"] :@"Oops!" :nil];
                        }
                        [AppDelegate sharedDelegate].isLoginOrRegister = NO;
                        [AppDelegate sharedDelegate].sessionId = user.uid;
                        [AppDelegate sharedDelegate].userEmail = user.email;
                        [AppDelegate sharedDelegate].userName = _txtUsername.text;
                        [AppDelegate sharedDelegate].userFirstName = _txtFirstName.text;
                        [AppDelegate sharedDelegate].userLastName = _txtLastName.text;
                        [AppDelegate sharedDelegate].completeNumber = @"0";
                        [AppDelegate sharedDelegate].sharedNumber = @"0";
                        [AppDelegate sharedDelegate].curUserProfileImageUrl =[NSString stringWithFormat:@"%@", metadata.downloadURL];
                        
                        [[AppDelegate sharedDelegate] saveLoginData];
//                        NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
//                        [userInfoForPost setValue:_txtEmail.text forKey:@"email"];
//                        [userInfoForPost setValue:_txtFirstName.text forKey:@"firstName"];
//                        [userInfoForPost setValue:_txtLastName.text forKey:@"lastName"];
//                        [userInfoForPost setValue:_txtUsername.text forKey:@"username"];
//                        [userInfoForPost setValue:[NSString stringWithFormat:@"%@", metadata.downloadURL] forKey:@"profileUrl"];
//                        
//                        FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
//                        FIRDatabaseReference *rootRForResgiter = [[rootR child:@"user info"] child:[AppDelegate sharedDelegate].userName];
//                        [rootRForResgiter setValue:userInfoForPost];
                        
                        
                        [[AppDelegate sharedDelegate] gotToGYMSelected];
                        
                    }];
                }else{
                    [AppDelegate sharedDelegate].isLoginOrRegister = NO;
                    [AppDelegate sharedDelegate].sessionId = user.uid;
                    [AppDelegate sharedDelegate].userEmail = user.email;
                    [AppDelegate sharedDelegate].userName = _txtUsername.text;
                    [AppDelegate sharedDelegate].userFirstName = _txtFirstName.text;
                    [AppDelegate sharedDelegate].userLastName = _txtLastName.text;
                    [AppDelegate sharedDelegate].completeNumber = @"0";
                    [AppDelegate sharedDelegate].sharedNumber = @"0";
                    [AppDelegate sharedDelegate].curUserProfileImageUrl = @"";
                    [AppDelegate sharedDelegate].aboutMe = @"";
                    [AppDelegate sharedDelegate].goal = @"";
                    [AppDelegate sharedDelegate].currentGym = @"";
                    
                    [[AppDelegate sharedDelegate] saveLoginData];
//                    NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
//                    [userInfoForPost setValue:_txtEmail.text forKey:@"email"];
//                    [userInfoForPost setValue:_txtFirstName.text forKey:@"firstName"];
//                    [userInfoForPost setValue:_txtLastName.text forKey:@"lastName"];
//                    [userInfoForPost setValue:_txtUsername.text forKey:@"username"];
//                    [userInfoForPost setValue:@"" forKey:@"profileUrl"];
//                    [userInfoForPost setValue:@"0" forKey:@"completeNumber"];
//                    [userInfoForPost setValue:@"0" forKey:@"sharedNumber"];
//                    [userInfoForPost setValue:@"" forKey:@"aboutMe"];
//                    [userInfoForPost setValue:@"" forKey:@"goal"];
//                    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
//                    FIRDatabaseReference *rootRForResgiter = [[rootR child:@"user info"] child:_txtUsername.text];
//                    [rootRForResgiter setValue:userInfoForPost];
                    
                    
                    [[AppDelegate sharedDelegate] gotToGYMSelected];
                }
                
                
            }
        }];
        

    }
    
}

- (IBAction)onSetProfileImage:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take profile photo", @"Choose from library", nil];
    [actionSheet showInView:self.view];
}
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

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //Go to Login Screen
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }
    
//    if (buttonIndex == actionSheet.destructiveButtonIndex) {
//        if (_photoMode == TAG_PROFILE_IMAGE){
//            //[self removePhoto];
//        }else if (_photoMode == TAG_WALLPAPER){
//            // [self removeWallpaper];
//        }
//        return;
//    }
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    
    if (buttonIndex == actionSheet.numberOfButtons - 3) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.allowsEditing = YES;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    } else if (buttonIndex == actionSheet.numberOfButtons - 2) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.allowsEditing = YES;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    }
    
    imgPicker.delegate = self;
    
    // [self saveData];
    [self presentViewController:imgPicker animated:YES completion:nil];
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(640, 640) interpolationQuality:kCGInterpolationDefault];
    image = [image fixOrientation];
    
    if (![UIImageJPEGRepresentation(image, 0.5f) writeToFile:[NSTemporaryDirectory() stringByAppendingString:@"/image.jpg"] atomically:YES]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save information. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^(void){
           [self uploadPhoto:image];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)uploadPhoto:(UIImage *)img{
    profileImg = img;
    [userProfileBut setImage:img forState:UIControlStateNormal];
}
@end
