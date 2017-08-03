//
//  AppDelegate.m
//  FitNectApp
//
//  Created by stepanekdavid on 8/23/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "SelectGYMViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "AddEditWorkOutsViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterIOS7Style.h"
@import Firebase;

@interface AppDelegate ()<FIRMessagingDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

@synthesize sessionId;
@synthesize userName;
@synthesize userEmail;
@synthesize userLastName;
@synthesize userFirstName;
@synthesize sharedNumber;
@synthesize completeNumber;
@synthesize currentGym;
@synthesize currentHelpforExercies;
@synthesize isSelectedCar;
@synthesize curUserProfileImageUrl;
@synthesize aboutMe, goal, level;
@synthesize isShownWelcome, isShownTipViewForWorkout;

@synthesize isLoginOrRegister;
@synthesize isFitLove;
@synthesize isRegister;
@synthesize isLogin;
@synthesize isFaceBookLogin, notifi;

@synthesize  workoutSelectedType, notifiCount;

@synthesize availWorkouts;
@synthesize addOrEditWorkOutsArray;
+(AppDelegate*)sharedDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    isLoginOrRegister = NO;
    isFitLove = NO;
    isSelectedCar = NO;
    isRegister= NO;
    isLogin = NO;
    isFaceBookLogin = NO;
    
    currentGym = @"No Gym";
    notifi = @"";
    currentHelpforExercies = @"";
    curUserProfileImageUrl = @"";
    workoutSelectedType = 1;
    notifiCount = 0;
    
    [FIRApp configure];
    
    [self getPushnotificationFromFirebase];
    
    availWorkouts = [[NSMutableArray alloc] init];
    addOrEditWorkOutsArray = [[NSMutableDictionary alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    UINavigationBar* navAppearance = [UINavigationBar appearance];
    UIImage *imgForBack = [ self imageWithColor:[UIColor colorWithRed:39.0f/255.0f green:54.0f/255.0f blue:183.0f/255.0f alpha:1.0f]];
    [navAppearance setBackgroundImage:imgForBack forBarMetrics:UIBarMetricsDefault];
    
    //    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:25.0f], NSFontAttributeName,
    //                                [UIColor colorWithRed:112/255.0f green:91/255.0f blue:131/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil];
    //    [navAppearance setTitleTextAttributes:attributes];
    [navAppearance setTintColor:[UIColor whiteColor]];
    [navAppearance setBarTintColor:[UIColor colorWithRed:39.0f/255.0f green:54.0f/255.0f blue:183.0f/255.0f alpha:1.0f]];
    
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"iTunesMetadata.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        NSLog(@"From App Store!");
    }
    NSLog(@"Route: %@", TEMP_IMAGE_PATH);
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
        #if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =   UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
        
        // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        // For iOS 10 data message (sent via FCM)
            [FIRMessaging messaging].remoteMessageDelegate = self;
        #endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    return YES;
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterIOS7Style new];
    
    [JCNotificationCenter
     enqueueNotificationWithTitle:@""
     message:notifi
     tapHandler:^{
         
     }];
    
    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"Notification"    message:@"This local notification"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [notificationAlert show];
    // NSLog(@"didReceiveLocalNotification");
}
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (notificationSettings != UIUserNotificationTypeNone)
    {
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    //    //source: http://stackoverflow.com/a/9372848/5309449
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"hexToken: %@",hexToken);
    
    
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"Failed to register: %@",error);
}
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
-(void)showAlert:(NSString*)msg :(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
- (void)saveLoginData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[AppDelegate sharedDelegate].sessionId forKey:@"sessionId"];
    [userDefaults setObject:[AppDelegate sharedDelegate].userEmail forKey:@"user_email"];
    [userDefaults setObject:[AppDelegate sharedDelegate].userFirstName forKey:@"first_name"];
    [userDefaults setObject:[AppDelegate sharedDelegate].userName forKey:@"user_name"];
    [userDefaults setObject:[AppDelegate sharedDelegate].userLastName forKey:@"last_name"];
    [userDefaults setObject:[AppDelegate sharedDelegate].completeNumber forKey:@"completeNumber"];
    [userDefaults setObject:[AppDelegate sharedDelegate].sharedNumber forKey:@"sharedNumber"];
    [userDefaults setObject:@0 forKey:@"fitlove"];
    [userDefaults setObject:[AppDelegate sharedDelegate].curUserProfileImageUrl forKey:@"profileUrl"];
    [userDefaults setObject:[AppDelegate sharedDelegate].aboutMe forKey:@"aboutMe"];
    [userDefaults setObject:[AppDelegate sharedDelegate].goal forKey:@"goal"];
    [userDefaults setObject:[AppDelegate sharedDelegate].currentGym forKey:@"currentGym"];
    [userDefaults setObject:[AppDelegate sharedDelegate].level forKey:@"level"];
    [userDefaults setBool:[AppDelegate sharedDelegate].isShownWelcome forKey:@"isShowingWelcome"];
    [userDefaults setBool:[AppDelegate sharedDelegate].isShownTipViewForWorkout forKey:@"isShowingTipViewForWorkout"];
    [userDefaults setBool:[AppDelegate sharedDelegate].notifiCount forKey:@"notifiCount"];
    [userDefaults synchronize];
}

- (BOOL)loadLoginData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"sessionId"]) {
        [AppDelegate sharedDelegate].sessionId = [userDefaults objectForKey:@"sessionId"];
        [AppDelegate sharedDelegate].userEmail = [userDefaults objectForKey:@"user_email"];
        [AppDelegate sharedDelegate].userFirstName = [userDefaults objectForKey:@"first_name"];
        [AppDelegate sharedDelegate].userLastName = [userDefaults objectForKey:@"last_name"];
        [AppDelegate sharedDelegate].userName = [userDefaults objectForKey:@"user_name"];
        [AppDelegate sharedDelegate].completeNumber = [userDefaults objectForKey:@"completeNumber"];
        [AppDelegate sharedDelegate].sharedNumber = [userDefaults objectForKey:@"sharedNumber"];
        [AppDelegate sharedDelegate].curUserProfileImageUrl = [userDefaults objectForKey:@"profileUrl"];
        [AppDelegate sharedDelegate].isFitLove = [[userDefaults objectForKey:@"fitlove"] boolValue];
        [AppDelegate sharedDelegate].aboutMe = [userDefaults objectForKey:@"aboutMe"];
        [AppDelegate sharedDelegate].goal = [userDefaults objectForKey:@"goal"];
        [AppDelegate sharedDelegate].currentGym = [userDefaults objectForKey:@"currentGym"];
        [AppDelegate sharedDelegate].level = [userDefaults objectForKey:@"level"];
        [AppDelegate sharedDelegate].isShownWelcome = [[userDefaults objectForKey:@"isShowingWelcome"] boolValue];
        [AppDelegate sharedDelegate].isShownTipViewForWorkout = [[userDefaults objectForKey:@"isShowingTipViewForWorkout"] boolValue];
        [AppDelegate sharedDelegate].notifiCount = [[userDefaults objectForKey:@"notifiCount"] integerValue];
        return YES;
    }
    return NO;
}

- (void)deleteLoginData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"sessionId"];
    [userDefaults removeObjectForKey:@"user_email"];
    [userDefaults removeObjectForKey:@"first_name"];
    [userDefaults removeObjectForKey:@"last_name"];
    [userDefaults removeObjectForKey:@"user_name"];
    [userDefaults removeObjectForKey:@"sharedNumber"];
    [userDefaults removeObjectForKey:@"completeNumber"];
    [userDefaults removeObjectForKey:@"fitlove"];
    [userDefaults removeObjectForKey:@"profileUrl"];
    [userDefaults removeObjectForKey:@"aboutMe"];
    [userDefaults removeObjectForKey:@"goal"];
    [userDefaults removeObjectForKey:@"currentGym"];
    [userDefaults removeObjectForKey:@"level"];
    [userDefaults removeObjectForKey:@"isShowingWelcome"];
    [userDefaults removeObjectForKey:@"isShowingTipViewForWorkout"];
    [userDefaults removeObjectForKey:@"notifiCount"];
    [userDefaults synchronize];
    [AppDelegate sharedDelegate].sessionId = nil;
    [AppDelegate sharedDelegate].userEmail = nil;
    [AppDelegate sharedDelegate].userFirstName = nil;
    [AppDelegate sharedDelegate].userLastName = nil;
    [AppDelegate sharedDelegate].userName = nil;
    [AppDelegate sharedDelegate].completeNumber = nil;
    [AppDelegate sharedDelegate].sharedNumber = nil;
    [AppDelegate sharedDelegate].curUserProfileImageUrl = nil;
    [AppDelegate sharedDelegate].isFitLove = NO;
    [AppDelegate sharedDelegate].aboutMe = nil;
    [AppDelegate sharedDelegate].goal = nil;
    [AppDelegate sharedDelegate].currentGym = nil;
    [AppDelegate sharedDelegate].level = nil;
    [AppDelegate sharedDelegate].isShownWelcome = NO;
    [AppDelegate sharedDelegate].isShownTipViewForWorkout = NO;
    [AppDelegate sharedDelegate].notifiCount = 0;
}
- (void)gotoAddWorkoutsView{
    AddEditWorkOutsViewController *viewcontroller = [[AddEditWorkOutsViewController alloc] initWithNibName:@"AddEditWorkOutsViewController" bundle:nil];
    viewcontroller.arrAddWorkouts = [AppDelegate sharedDelegate].addOrEditWorkOutsArray;
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
    [controller.navigationBar setTranslucent:NO];
    self.window.rootViewController = controller;
}
- (void)goToMainContact
{
    
    MainViewController *tabRequestController = [MainViewController sharedController];
    tabRequestController.selectedIndex = 0;
    
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:tabRequestController];
    [controller.navigationBar setTranslucent:NO];
    self.window.rootViewController = controller;
    
}
- (void)gotToGYMSelected{
    SelectGYMViewController *viewcontroller = [[SelectGYMViewController alloc] initWithNibName:@"SelectGYMViewController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
    [controller.navigationBar setTranslucent:NO];
    self.window.rootViewController = controller;
    
}
-(void)goToSplash{
    isLogin = YES;
    LoginViewController *viewcontroller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
    [controller.navigationBar setTranslucent:NO];
    self.window.rootViewController = controller;
}
- (void)getPushnotificationFromFirebase{
    
    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/notification"];
    
    [[rootR queryOrderedByKey] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot){
        NSDictionary *dict = snapshot.value;
        // if ([snapshot.key isEqualToString:@"user info"]) {
        NSString *notificationTxt = @"";
        for (NSString *snap in dict) {
            NSDictionary *oneNotification = [dict objectForKey:snap];
            if ([oneNotification objectForKey:@"notifReceiver"] && [[oneNotification objectForKey:@"notifReceiver"] isEqualToString:userName]) {
                notificationTxt = [NSString stringWithFormat:@"%@ has liked your workout", [oneNotification objectForKey:@"notifSender"]];
            }
        }
        notifi = notificationTxt;
        NSInteger count = snapshot.childrenCount;
        BOOL sendNotif = NO;
        if (notifiCount == 0) {
            notifiCount = count;
            [self saveLoginData];
        }else if (count > notifiCount) {
            sendNotif = YES;
            notifiCount = count;
            [self saveLoginData];
        }
        if (sendNotif && ![notificationTxt isEqualToString:@""]) {
        //if (sendNotif) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:7];
            notification.alertBody = notificationTxt;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.applicationIconBadgeNumber = 1;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
    withCancelBlock:^(NSError *error){
        NSLog(@"%@", error.description);
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:refreshedToken forKey:@"FIRMessagingToken"];
}
- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", remoteMessage.appData);
}
#endif

// With "FirebaseAppDelegateProxyEnabled": NO
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    // Let FCM know about the message for analytics etc.
//    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
//    // handle your message.
//}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
//    if (userInfo[kGCMMessageIDKey]) {
//        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
//    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
//    if (userInfo[kGCMMessageIDKey]) {
//        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
//    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.FitNect.FitNect" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FitNectApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FitNectApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

