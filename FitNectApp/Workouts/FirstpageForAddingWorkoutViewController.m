//
//  FirstpageForAddingWorkoutViewController.m
//  FitNectApp
//
//  Created by stepanekdavid on 12/12/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "FirstpageForAddingWorkoutViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SettingViewController.h"
#import "AddEditWorkOutsViewController.h"
#import "UIButton+AFNetworking.h"
#import "UIImage+Resize.h"
#import "AppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import Firebase;
@import FirebaseStorage;

@interface FirstpageForAddingWorkoutViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSArray *workoutTypeArray;
    UIImage *changedImg;
    int typeForActionsheet;
    NSString *workoutImageUrl;
    NSString *currentWorkoutType;
    
    BOOL isSetWorkoutsImage;
    
    NSInteger currendGoalPostion;
    
    BOOL admin;
}

@end

@implementation FirstpageForAddingWorkoutViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    
    typeForActionsheet = 1;
    workoutImageUrl= @"";
    WorkoutTypeTableview.hidden = YES;
    workoutTypeArray = [[NSArray alloc] initWithObjects: @"Strength Training",@"Cardio Training",@"Trainer Workout", nil];
    currentWorkoutType =@"Trainer Workout";
    currendGoalPostion = 0;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    isSetWorkoutsImage = NO;
    admin = NO;
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
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)handleTap
{
    [self.view endEditing:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [workoutTypeArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *sortTableViewIdentifier = @"WorkoutTypeTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sortTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sortTableViewIdentifier];
    }
    cell.textLabel.text =[workoutTypeArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [typeWorkouts setTitle:[workoutTypeArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    currendGoalPostion =indexPath.row;
    currentWorkoutType = [workoutTypeArray objectAtIndex:indexPath.row];
    WorkoutTypeTableview.hidden = YES;
    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMenu:(id)sender {
    typeForActionsheet = 1;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Setting", @"Logout", nil];
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 2) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }
    if (typeForActionsheet == 1) {
        switch (buttonIndex) {
            case 0:
            {
                SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
                [self presentViewController:viewController animated:YES completion:nil];
            }
                break;
            case 1:{
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
- (IBAction)onWorkoutType:(id)sender {
    WorkoutTypeTableview.hidden = NO;
}

- (IBAction)onUseProfile:(id)sender {
    if (![[AppDelegate sharedDelegate].curUserProfileImageUrl isEqualToString:@""]) {
        NSLog(@"%@", [AppDelegate sharedDelegate].curUserProfileImageUrl);
        [btnWorkourtProfileImage setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[AppDelegate sharedDelegate].curUserProfileImageUrl]];
        workoutImageUrl = [AppDelegate sharedDelegate].curUserProfileImageUrl;
        isSetWorkoutsImage = YES;
    }else{
        [self showAlert:@"No profile picture has been set" :@"Failed" :nil];
        isSetWorkoutsImage = NO;
    }
}

- (IBAction)onLoadWorkoutImage:(id)sender {
   // if (![AppDelegate sharedDelegate].isFaceBookLogin) {
        typeForActionsheet = 2;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take profile photo", @"Choose from library", nil];
        [actionSheet showInView:self.view];
   // }
}

- (IBAction)onStartAddingExercises:(id)sender {
    if (!txtWorkoutName.text.length) {
        [self showAlert:@"Workout must have a title." :@"Input Error" :nil];
        return;
    }
    if (currendGoalPostion == 2 && !admin) {
        [self showAlert:@"Must be a FitShare certified trainer to post under Trainer Workouts" :@"Error" :nil];
        return;
    }
    if (!isSetWorkoutsImage) {
        [self showAlert:@"Workout must include an image." :@"Input Error" :nil];
        return;
    }
    AddEditWorkOutsViewController *addEditWorkOutsViewController = [[AddEditWorkOutsViewController alloc] initWithNibName:nil bundle:nil];
    addEditWorkOutsViewController.workoutsImageUrl = workoutImageUrl;
    addEditWorkOutsViewController.workoutName = txtWorkoutName.text;
    addEditWorkOutsViewController.workoutType = currentWorkoutType;
    [self.navigationController pushViewController:addEditWorkOutsViewController animated:YES];
}
-(void)showAlert:(NSString*)msg :(NSString*)title :(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
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
    changedImg = img;
    
    FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:@"gs://fitnectapp.appspot.com"];
    NSData *imageData = UIImageJPEGRepresentation(changedImg, 0.8);
    NSString *imagePath = [NSString stringWithFormat:@"profile/%@_%lld.jpg",[FIRAuth auth].currentUser.uid, (long long)([[NSDate date] timeIntervalSince1970] * 1000.0)];
    FIRStorageMetadata *metadata = [FIRStorageMetadata new];
    metadata.contentType = @"image/jpeg";
    [[storageRef child:imagePath] putData:imageData metadata:metadata completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (error) {
            NSLog(@"Error uploading: %@", error);
            NSDictionary * errorDic = error.userInfo;
            [self showAlert:[errorDic objectForKey:@"NSLocalizedDescription"] :@"Oops!" :nil];
        }
        workoutImageUrl = [NSString stringWithFormat:@"%@",metadata.downloadURL];
        [btnWorkourtProfileImage setImage:img forState:UIControlStateNormal];
        isSetWorkoutsImage = YES;
    }];
}
@end
