//
//  AppDelegate.h
//  FitNectApp
//
//  Created by stepanekdavid on 8/23/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class LoginViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
+(AppDelegate*)sharedDelegate;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (nonatomic,retain) NSString *sessionId;
@property (nonatomic,retain) NSString *userEmail;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *userFirstName;
@property (nonatomic,retain) NSString *userLastName;
@property (nonatomic,retain) NSString *completeNumber;
@property (nonatomic,retain) NSString *sharedNumber;
@property (nonatomic,retain) NSString *curUserProfileImageUrl;
@property (nonatomic,retain) NSString *aboutMe;
@property (nonatomic,retain) NSString *goal;
@property (nonatomic,retain) NSString *level;
@property NSInteger notifiCount;
@property BOOL isShownWelcome;
@property BOOL isShownTipViewForWorkout;


@property  NSInteger workoutSelectedType;

@property (nonatomic, retain) NSString *currentGym;
@property (nonatomic, retain) NSString *currentHelpforExercies;

@property (nonatomic, retain) NSString *notifi;


@property (nonatomic, retain) NSMutableArray *availWorkouts;

@property (nonatomic, retain) NSMutableDictionary *addOrEditWorkOutsArray;

@property BOOL isLoginOrRegister;
@property BOOL isFitLove;
@property BOOL isSelectedCar;
@property BOOL isRegister;
@property BOOL isLogin;

@property BOOL isFaceBookLogin;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveLoginData;
- (BOOL)loadLoginData;
- (void)deleteLoginData;

- (void)goToMainContact;
- (void)goToSplash;
- (void)gotToGYMSelected;

- (void)gotoAddWorkoutsView;

@end

