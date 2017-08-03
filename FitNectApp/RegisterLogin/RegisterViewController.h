//
//  RegisterViewController.h
//  FitNect
//
//  Created by stepanekdavid on 7/25/15.
//  Copyright © 2015 jella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>{
    
    __weak IBOutlet UIScrollView *scrView;
    __weak IBOutlet UIButton *userProfileBut;
    
    __weak IBOutlet UILabel *lblPassword1;
    __weak IBOutlet UILabel *lblPassword2;
    
    BOOL showKeyboard;
}
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtpassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property BOOL isFlag;


- (IBAction)onRegisterClick:(id)sender;
- (IBAction)onSetProfileImage:(id)sender;

@end
