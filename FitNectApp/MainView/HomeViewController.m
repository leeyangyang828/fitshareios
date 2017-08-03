//
//  HomeViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/25/15.
//  Copyright © 2015 jella. All rights reserved.
//

#import "HomeViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "AddEditWorkOutsViewController.h"
#import "PreviewWorkOutsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+Resize.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "NotificationViewController.h"
#import "OwnWorkoutCell.h"

#import "FirstpageForAddingWorkoutViewController.h"

@import Firebase;
@import FirebaseStorage;
@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>{
    UIImage *changedProfileImg;
    int typeForActionsheet;
    NSArray *arrayGoal;
    
    BOOL isHome;
}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    typeForActionsheet = 1;
    
    currentUserProfileImge.imageView.contentMode = UIViewContentModeScaleAspectFill;
    currentUserProfileImge.clipsToBounds = YES;
    currentUserProfileImge.layer.cornerRadius = CGRectGetWidth(currentUserProfileImge.frame) / 2;
    
    currentUserProfileImageView.contentMode = UIViewContentModeScaleAspectFill;
    currentUserProfileImageView.clipsToBounds = YES;
    currentUserProfileImageView.layer.cornerRadius = CGRectGetWidth(currentUserProfileImageView.frame) / 2;
    
    if (![[AppDelegate sharedDelegate].curUserProfileImageUrl isEqualToString:@""]) {
        
//            [[[FIRStorage storage] referenceForURL:[AppDelegate sharedDelegate].curUserProfileImageUrl] dataWithMaxSize:INT64_MAX completion:^(NSData *data, NSError *error) {
//                if (error) {
//                    NSLog(@"Error downloading: %@", error);
//                    return;
//                }
//                [currentUserProfileImge setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
//            }];
        NSLog(@"%@", [AppDelegate sharedDelegate].curUserProfileImageUrl);
        [currentUserProfileImageView setImageWithURL:[NSURL URLWithString:[AppDelegate sharedDelegate].curUserProfileImageUrl]];
    }
    
    currentEmail.text = [NSString stringWithFormat:@"Email: %@", [AppDelegate sharedDelegate].userEmail];
    currentUsername.text = [NSString stringWithFormat:@"Username: %@", [AppDelegate sharedDelegate].userName];
    [btnMyGym setTitle:[NSString stringWithFormat:@"My Gym: %@", [AppDelegate sharedDelegate].currentGym] forState:UIControlStateNormal];
    
    GoalTableView.hidden = YES;
    
    arrayGoal = [[NSArray alloc] initWithObjects:@"Set Goal",@"Bodybuilding", @"Cardio Training", @"Crossfit",@"Powerlifting", @"Sports Training",nil];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    if ([[AppDelegate sharedDelegate].goal isEqualToString:@""]) {
        currentGoal.text = @"Set Goal";
    }else{
        currentGoal.text = [AppDelegate sharedDelegate].goal;
    }
    aboutMe.text = [AppDelegate sharedDelegate].aboutMe;
    
    changedUserNameView.hidden = YES;
    changedEmailView.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IS_IPHONE_5) {
        [navView setFrame:CGRectMake(0, 0, 320, 44)];
    }else{
        
        [navView setFrame:CGRectMake(0, 0, self.view.superview.frame.size.width, 44)];
    }
    [self.navigationController.navigationBar addSubview:navView];
    
    compledtedHomeNum.text = [NSString stringWithFormat:@"%@ Workouts completed", [AppDelegate sharedDelegate].completeNumber];
    sharedHomeNum.text = [NSString stringWithFormat:@"%@ Workouts shared", [AppDelegate sharedDelegate].sharedNumber];
    
    if ([[AppDelegate sharedDelegate].aboutMe isEqualToString:@""] && [[AppDelegate sharedDelegate].goal isEqualToString:@""]) {
        lblAboutMeGoal.text = @"Add a short 'About Me' and your current goals here!";
    }else{
        if ([AppDelegate sharedDelegate].aboutMe) {
            lblAboutMeGoal.text = [NSString stringWithFormat:@"%@\nGoal: %@", [AppDelegate sharedDelegate].aboutMe, [AppDelegate sharedDelegate].goal];
        }else{
            
            lblAboutMeGoal.text = [NSString stringWithFormat:@"\nGoal: %@", [AppDelegate sharedDelegate].goal];
        }
    }
    NSInteger completedNum = [[AppDelegate sharedDelegate].completeNumber integerValue];
    if (completedNum < 10) {
        [AppDelegate sharedDelegate].level = @"Silver Trainer";
        trainerLevel.text = [AppDelegate sharedDelegate].level;
    }
    if (completedNum >= 10 && completedNum < 30){
        [AppDelegate sharedDelegate].level = @"Ruby Trainer";
        trainerLevel.text = [AppDelegate sharedDelegate].level;
    }
    if (completedNum >= 30 && completedNum < 50){
        [AppDelegate sharedDelegate].level = @"Gold Trainer";
        trainerLevel.text = [AppDelegate sharedDelegate].level;
    }
    if (completedNum >= 75 && completedNum < 100){
        [AppDelegate sharedDelegate].level = @"Diamond Trainer";
        trainerLevel.text = [AppDelegate sharedDelegate].level;
    }
    if (completedNum >= 150){
        [AppDelegate sharedDelegate].level = @"Platinum Trainer";
        trainerLevel.text = [AppDelegate sharedDelegate].level;
    }
    
    isHome = YES;

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
    isHome = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onHomeMenu:(id)sender {
    
    typeForActionsheet = 1;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Logout", nil];
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (typeForActionsheet == 1) {
        if (buttonIndex == 1) {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            return;
        }
        switch (buttonIndex) {
            case 1:
            {
                SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
                [self presentViewController:viewController animated:YES completion:nil];
            }
                break;
            case 0:{
                FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                [loginManager logOut];
                
                [FBSDKAccessToken setCurrentAccessToken:nil];
                
                NSError *error;
                [[FIRAuth auth] signOut:&error];
                if (!error) {
                    // Sign-out succeeded
                    
                    [[AppDelegate sharedDelegate] deleteLoginData];
                    [[AppDelegate sharedDelegate] goToSplash];
                }
            }
                break;
            default:
                break;
        }
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else{
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
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
- (IBAction)onViewProfile:(id)sender {
}

- (IBAction)onNotification:(id)sender {
    NotificationViewController *vc = [[NotificationViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Please select your Goal:";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayGoal count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *sortTableViewIdentifier = @"GoalItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sortTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sortTableViewIdentifier];
    }
    cell.textLabel.text =[arrayGoal objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [AppDelegate sharedDelegate].goal = [arrayGoal objectAtIndex:indexPath.row];
    [[AppDelegate sharedDelegate] saveLoginData];
    if ([[AppDelegate sharedDelegate].aboutMe isEqualToString:@""] && [[AppDelegate sharedDelegate].goal isEqualToString:@""]) {
        lblAboutMeGoal.text = @"Add a short 'About Me' and your current goals here!";
    }else{
        if ([AppDelegate sharedDelegate].aboutMe) {
            lblAboutMeGoal.text = [NSString stringWithFormat:@"%@\nGoal: %@", [AppDelegate sharedDelegate].aboutMe, [AppDelegate sharedDelegate].goal];
        }else{
            
            lblAboutMeGoal.text = [NSString stringWithFormat:@"\nGoal: %@", [AppDelegate sharedDelegate].goal];
        }
    }
    GoalTableView.hidden = YES;
    currentGoal.text = [arrayGoal objectAtIndex:indexPath.row];
    
    NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
    
    [userInfoForPost setValue:[AppDelegate sharedDelegate].userEmail forKey:@"email"];
    [userInfoForPost setValue:[AppDelegate sharedDelegate].userFirstName forKey:@"firstName"];
    [userInfoForPost setValue:[AppDelegate sharedDelegate].userLastName forKey:@"lastName"];
    [userInfoForPost setValue:[AppDelegate sharedDelegate].userName forKey:@"username"];
    [userInfoForPost setValue:[AppDelegate sharedDelegate].curUserProfileImageUrl forKey:@"profileUrl"];
    [userInfoForPost setValue:[AppDelegate sharedDelegate].completeNumber forKey:@"completeNumber"];
    [userInfoForPost setValue:[AppDelegate sharedDelegate].sharedNumber forKey:@"sharedNumber"];
    [userInfoForPost setValue:[AppDelegate sharedDelegate].goal forKey:@"goal"];
    [userInfoForPost setValue:[AppDelegate sharedDelegate].currentGym forKey:@"gym"];
    [userInfoForPost setValue:[AppDelegate sharedDelegate].aboutMe forKey:@"aboutMe"];
    
    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
    FIRDatabaseReference *rootRForHaveingSharedNum = [rootR child:@"user info"];
    if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
        FIRDatabaseReference *rootRForAdding = [rootRForHaveingSharedNum child:[AppDelegate sharedDelegate].userName];
        [rootRForAdding setValue:userInfoForPost];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:aboutMe]) {
        NSString *compareStr = @"";
        if (range.location == aboutMe.text.length) {
            compareStr  = [aboutMe.text stringByAppendingString:string];
        }else if (range.location == aboutMe.text.length-1){
            compareStr = [aboutMe.text substringToIndex:aboutMe.text.length-1];
        }
        [AppDelegate sharedDelegate].aboutMe = compareStr;
        [[AppDelegate sharedDelegate] saveLoginData];
        if ([[AppDelegate sharedDelegate].aboutMe isEqualToString:@""] && [[AppDelegate sharedDelegate].goal isEqualToString:@""]) {
            lblAboutMeGoal.text = @"Add a short 'About Me' and your current goals here!";
        }else{
            if ([AppDelegate sharedDelegate].aboutMe) {
                lblAboutMeGoal.text = [NSString stringWithFormat:@"%@\nGoal: %@", [AppDelegate sharedDelegate].aboutMe, [AppDelegate sharedDelegate].goal];
            }else{
                
                lblAboutMeGoal.text = [NSString stringWithFormat:@"\nGoal: %@", [AppDelegate sharedDelegate].goal];
            }
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField isEqual:aboutMe]) {
        [AppDelegate sharedDelegate].aboutMe = aboutMe.text;
        [[AppDelegate sharedDelegate] saveLoginData];
        if ([[AppDelegate sharedDelegate].aboutMe isEqualToString:@""] && [[AppDelegate sharedDelegate].goal isEqualToString:@""]) {
            lblAboutMeGoal.text = @"Add a short 'About Me' and your current goals here!";
        }else{
            if ([AppDelegate sharedDelegate].aboutMe) {
                lblAboutMeGoal.text = [NSString stringWithFormat:@"%@\nGoal: %@", [AppDelegate sharedDelegate].aboutMe, [AppDelegate sharedDelegate].goal];
            }else{
                
                lblAboutMeGoal.text = [NSString stringWithFormat:@"\nGoal: %@", [AppDelegate sharedDelegate].goal];
            }
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:txtCurrentUsername]) {
        [txtNewUsername becomeFirstResponder];
    }else if ([textField isEqual:txtNewUsername]){
        [self onChangedUserName:nil];
    }
    return YES;
}
-(void)handleTap
{
    [self.view endEditing:YES];
}
- (IBAction)onChangeProfileImage:(id)sender {
    //if (![AppDelegate sharedDelegate].isFaceBookLogin) {
        typeForActionsheet = 2;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take profile photo", @"Choose from library", nil];
        [actionSheet showInView:self.view];
    //}
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    if([touch.view isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    // UITableViewCellContentView => UITableViewCell
    if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    // UITableViewCellContentView => UITableViewCellScrollView => UITableViewCell
    if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    return YES;
}
- (IBAction)onAddWorkouts:(id)sender {
    FirstpageForAddingWorkoutViewController *addEditWorkOutsViewController = [[FirstpageForAddingWorkoutViewController alloc] initWithNibName:nil bundle:nil];
    //[self presentViewController:loginViewController animated:YES completion:NULL];
    [self.navigationController pushViewController:addEditWorkOutsViewController animated:YES];
}

- (IBAction)onSettingView:(id)sender {
    SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)onSetGoal:(id)sender {
    [self.view endEditing:YES];
    GoalTableView.hidden = NO;
}

- (IBAction)onGym:(id)sender {
    [self.view endEditing:YES];
    [[AppDelegate sharedDelegate] gotToGYMSelected];
}

- (IBAction)onChangeEmail:(id)sender {
}

- (IBAction)onChangeUserName:(id)sender {
    changedUserNameView.hidden = NO;
    txtCurrentUsername.text = [AppDelegate sharedDelegate].userName;
}

- (IBAction)onChangedUserName:(id)sender {
    if (!txtCurrentUsername.text.length)
    {
        [self showAlert:@"Please fill in all fields to reset username." :@"Input Error" :nil];
        return;
    }
    if (!txtNewUsername.text.length)
    {
        [self showAlert:@"Please fill in all fields to reset username." :@"Input Error" :nil];
        return;
    }
    if (![[AppDelegate sharedDelegate].userName isEqualToString:txtCurrentUsername.text]) {
        [self showAlert:@"Username doesn't match!" :@"Input Error" :nil];
        return;
    }
    if ([txtNewUsername.text containsString:@"."]) {
        [self showAlert:@"Username must be a non-empty string and not contain '.', '#' ,'$' ,'[' or ']'" :@"Input Error" :nil];
        return;
    }else if ([txtNewUsername.text containsString:@"#"]){
        
        [self showAlert:@"Username must be a non-empty string and not contain '.', '#', '$', '[' or ']'" :@"Input Error" :nil];
        return;
    }else if ([txtNewUsername.text containsString:@"$"]){
        
        [self showAlert:@"Username must be a non-empty string and not contain '.', '#', '$', '[' or ']'" :@"Input Error" :nil];
        return;
    }else if ([txtNewUsername.text containsString:@"["]){
        
        [self showAlert:@"Username must be a non-empty string and not contain '.', '#', '$', '[' or ']'" :@"Input Error" :nil];
        return;
    }else if ([txtNewUsername.text containsString:@"]"]){
        
        [self showAlert:@"Username must be a non-empty string and not contain '.', '#', '$', '[' or ']'" :@"Input Error" :nil];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
    
    [[rootR queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (isHome && changedUserNameView.hidden == NO) {
            isHome = NO;
            NSDictionary *dict = snapshot.value;
            BOOL isFind = NO;
            for (NSString *username in [dict objectForKey:@"user info"]) {
                if ([username isEqualToString:txtNewUsername.text]) {
                    isFind = YES;
                }
            }
            if (!isFind) {
                [AppDelegate sharedDelegate].userName = txtNewUsername.text;
                [[AppDelegate sharedDelegate] saveLoginData];
                
                NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
                [userInfoForPost setValue:[AppDelegate sharedDelegate].userEmail forKey:@"email"];
                [userInfoForPost setValue:[AppDelegate sharedDelegate].userFirstName forKey:@"firstName"];
                [userInfoForPost setValue:[AppDelegate sharedDelegate].userLastName forKey:@"lastName"];
                [userInfoForPost setValue:[AppDelegate sharedDelegate].userName forKey:@"username"];
                [userInfoForPost setValue:[AppDelegate sharedDelegate].curUserProfileImageUrl forKey:@"profileUrl"];
                [userInfoForPost setValue:[AppDelegate sharedDelegate].completeNumber forKey:@"completeNumber"];
                [userInfoForPost setValue:[AppDelegate sharedDelegate].sharedNumber forKey:@"sharedNumber"];
                [userInfoForPost setValue:[AppDelegate sharedDelegate].goal forKey:@"goal"];
                [userInfoForPost setValue:[AppDelegate sharedDelegate].currentGym forKey:@"gym"];
                [userInfoForPost setValue:[AppDelegate sharedDelegate].aboutMe forKey:@"aboutMe"];
                if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
                    FIRDatabaseReference *rootRForResgiter = [[rootR child:@"user info"] child:[AppDelegate sharedDelegate].userName];
                    [rootRForResgiter setValue:userInfoForPost];
                }
                
                [[[rootR child:@"user info"] child:txtCurrentUsername.text] removeValue];
                changedUserNameView.hidden = YES;
                currentUsername.text =[NSString stringWithFormat:@"Username: %@", [AppDelegate sharedDelegate].userName];
            }else{
                [self showAlert:@"Username taken" :@"Error" :nil];
                return;
            }
        }
        
    }
    withCancelBlock:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        changedUserNameView.hidden = YES;
        currentUsername.text = [NSString stringWithFormat:@"Username: %@", [AppDelegate sharedDelegate].userName];;
        NSLog(@"%@", error.description);
    }];
}

- (IBAction)onChangedUserNameClose:(id)sender {
    changedUserNameView.hidden = YES;
    currentUsername.text = [NSString stringWithFormat:@"Username: %@", [AppDelegate sharedDelegate].userName];;
}

- (IBAction)onChangedEmail:(id)sender {
}

- (IBAction)onChangedEmailClose:(id)sender {
}

- (IBAction)onGetFacebookFriendsList:(id)sender {
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        if (!error) {
            NSLog(@"friends list : %@", result);
        }
    }];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    changedProfileImg = img;
    
    
    FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:@"gs://fitnectapp.appspot.com"];
    NSData *imageData = UIImageJPEGRepresentation(changedProfileImg, 0.8);
    NSString *imagePath = [NSString stringWithFormat:@"profile/%@_%lld.jpg",[FIRAuth auth].currentUser.uid, (long long)([[NSDate date] timeIntervalSince1970] * 1000.0)];
    FIRStorageMetadata *metadata = [FIRStorageMetadata new];
    metadata.contentType = @"image/jpeg";
    
    NSLog(@"imageurl--%@", [AppDelegate sharedDelegate].curUserProfileImageUrl);
    
    //if ([[AppDelegate sharedDelegate].curUserProfileImageUrl isEqualToString:@""]) {
        [[storageRef child:imagePath] putData:imageData metadata:metadata completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error) {
                NSLog(@"Error uploading: %@", error);
                NSDictionary * errorDic = error.userInfo;
                [self showAlert:[errorDic objectForKey:@"NSLocalizedDescription"] :@"Oops!" :nil];
            }
            
            [AppDelegate sharedDelegate].curUserProfileImageUrl =[NSString stringWithFormat:@"%@", metadata.downloadURL];
            
            [[AppDelegate sharedDelegate] saveLoginData];
            
            NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].userEmail forKey:@"email"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].userFirstName forKey:@"firstName"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].userLastName forKey:@"lastName"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].userName forKey:@"username"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].curUserProfileImageUrl forKey:@"profileUrl"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].completeNumber forKey:@"completeNumber"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].sharedNumber forKey:@"sharedNumber"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].goal forKey:@"goal"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].currentGym forKey:@"gym"];
            [userInfoForPost setValue:[AppDelegate sharedDelegate].aboutMe forKey:@"aboutMe"];
            
            FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
            
            FIRDatabaseReference *rootRForHaveingSharedNum = [rootR child:@"user info"];
            if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
            FIRDatabaseReference *rootRForAdding = [rootRForHaveingSharedNum child:[AppDelegate sharedDelegate].userName];
            [rootRForAdding setValue:userInfoForPost];
            }
            [currentUserProfileImageView setImage:img];
        }];
//    }else{
//        NSArray *arr1 = [[[[AppDelegate sharedDelegate].curUserProfileImageUrl componentsSeparatedByString:@"?"] objectAtIndex:0] componentsSeparatedByString:@"/"];
//        
//        NSString *urlfordeleting = [[arr1 objectAtIndex:7] stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
//        
//        // Create a reference to the file to delete
//        FIRStorageReference *desertRef = [storageRef child:urlfordeleting];
//        // Delete the file
//        [desertRef deleteWithCompletion:^(NSError *error){
//            if (error != nil) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                NSLog(@"Error uploading: %@", error);
//                NSDictionary * errorDic = error.userInfo;
//                [self showAlert:[errorDic objectForKey:@"NSLocalizedDescription"] :@"Oops!" :nil];
//            } else {
//                [[storageRef child:imagePath] putData:imageData metadata:metadata completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    if (error) {
//                        NSLog(@"Error uploading: %@", error);
//                        NSDictionary * errorDic = error.userInfo;
//                        [self showAlert:[errorDic objectForKey:@"NSLocalizedDescription"] :@"Oops!" :nil];
//                    }
//                    
//                    [AppDelegate sharedDelegate].curUserProfileImageUrl =[NSString stringWithFormat:@"%@", metadata.downloadURL];
//                    
//                    [[AppDelegate sharedDelegate] saveLoginData];
//                    
//                    NSMutableDictionary *userInfoForPost = [[NSMutableDictionary alloc] init];
//                    [userInfoForPost setValue:[AppDelegate sharedDelegate].completeNumber forKey:@"completeNumber"];
//                    [userInfoForPost setValue:[AppDelegate sharedDelegate].sharedNumber forKey:@"sharedNumber"];
//                    [userInfoForPost setValue:[AppDelegate sharedDelegate].userName forKey:@"username"];
//                    [userInfoForPost setValue:[AppDelegate sharedDelegate].userEmail forKey:@"email"];
//                    [userInfoForPost setValue:[AppDelegate sharedDelegate].userFirstName forKey:@"firstName"];
//                    [userInfoForPost setValue:[AppDelegate sharedDelegate].userLastName forKey:@"lastName"];
//                    [userInfoForPost setValue:[NSString stringWithFormat:@"%@", metadata.downloadURL] forKey:@"profileUrl"];
//                    
//                    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
//                    
//                    FIRDatabaseReference *rootRForHaveingSharedNum = [rootR child:@"user info"];
//                    FIRDatabaseReference *rootRForAdding = [rootRForHaveingSharedNum child:[AppDelegate sharedDelegate].userName];
//                    [rootRForAdding setValue:userInfoForPost];
//                    
//                    [currentUserProfileImageView setImage:img];
//                }];
//                
//            }
//        }];
//    }
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

@end
