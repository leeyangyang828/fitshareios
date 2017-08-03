//
//  MainViewController.m
//  FitNect
//
//  Created by stepanekdavid on 7/25/15.
//  Copyright © 2015 jella. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#define TABBARHEIGHT 58.0f
@import Firebase;

@interface MainViewController ()<UITabBarControllerDelegate, UIGestureRecognizerDelegate>{
    UIImageView *tabImageView;
    NSInteger currentScreenIndex;
}

@end

@implementation MainViewController

+ (MainViewController *)sharedController
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainViewController" owner:nil options:nil];
    MainViewController *sharedController = [array objectAtIndex:0];
    return sharedController;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    self.delegate = self;
    self.selectedIndex = 0;
    currentScreenIndex = 0;
    
    CGRect frame = self.tabBar.bounds;
    
    
    if (IS_IPHONE_5) {
        frame.size.height = 60;
    }else{
        frame.size.height = 75;
    }
    tabImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeSelected.png"]];
    tabImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:frame];
    
    [tabImageView setFrame:frame];
    [bottomView addSubview:tabImageView];
    [bottomView setBackgroundColor:[UIColor clearColor]];
    
    for (int i = 0; i < 2; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(frame.size.width/2 * i, 0, frame.size.width/2, bottomView.frame.size.height);
        button.tag = i;
        [button addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
    }
    
    NSLog(@"%@", self.tabBar);
    [self.tabBar addSubview:bottomView];
    [self.tabBar bringSubviewToFront:bottomView];
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
    
    leftSwipeRecognizer.delegate = self;
    rightSwipeRecognizer.delegate = self;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.tabBar invalidateIntrinsicContentSize];
    
    CGRect tabFrame = self.tabBar.frame;
    if (IS_IPHONE_5) {
        tabFrame.size.height = 60;
    }else{
        tabFrame.size.height = 75;
    }
    tabFrame.origin.y = self.view.frame.origin.y - 64;
    self.tabBar.frame = tabFrame;
    
    self.tabBar.translucent = NO;
    self.tabBar.translucent = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    NSMutableDictionary *userInfoForPostForPerson = [[NSMutableDictionary alloc] init];
    
    [userInfoForPostForPerson setValue:[AppDelegate sharedDelegate].userEmail forKey:@"email"];
    [userInfoForPostForPerson setValue:[AppDelegate sharedDelegate].userFirstName forKey:@"firstName"];
    [userInfoForPostForPerson setValue:[AppDelegate sharedDelegate].userLastName forKey:@"lastName"];
    [userInfoForPostForPerson setValue:[AppDelegate sharedDelegate].userName forKey:@"username"];
    [userInfoForPostForPerson setValue:[AppDelegate sharedDelegate].curUserProfileImageUrl forKey:@"profileUrl"];
    [userInfoForPostForPerson setValue:[AppDelegate sharedDelegate].completeNumber forKey:@"completeNumber"];
    [userInfoForPostForPerson setValue:[AppDelegate sharedDelegate].sharedNumber forKey:@"sharedNumber"];
    [userInfoForPostForPerson setValue:[AppDelegate sharedDelegate].goal forKey:@"goal"];
    [userInfoForPostForPerson setValue:[AppDelegate sharedDelegate].currentGym forKey:@"gym"];
    [userInfoForPostForPerson setValue:[AppDelegate sharedDelegate].aboutMe forKey:@"aboutMe"];
    
    FIRDatabaseReference *rootR = [[FIRDatabase database] referenceFromURL:@"https://fitnectapp.firebaseio.com/"];
    FIRDatabaseReference *rootRForHaveingSharedNum = [rootR child:@"user info"];
    if ([AppDelegate sharedDelegate].userName && ![[AppDelegate sharedDelegate].userName isEqualToString:@""]) {
    FIRDatabaseReference *rootRForAdding = [rootRForHaveingSharedNum child:[AppDelegate sharedDelegate].userName];
    [rootRForAdding setValue:userInfoForPostForPerson];
    }
}
- (void)swipeLeft:(id)sender
{
    if (currentScreenIndex < 1) {
        UIButton *button = (UIButton *)[self.view viewWithTag:currentScreenIndex+1];
        [self changeTab:button];
    }
    
}

- (void)swipeRight:(id)sender
{
    if (currentScreenIndex > 0) {
        UIButton *button = (UIButton *)[self.view viewWithTag:currentScreenIndex-1];
        [self changeTab:button];
    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"did exchange appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"will exchange disappear");
}

- (void)changeTab:(UIButton *)sender
{
    currentScreenIndex = sender.tag;
    if (sender.tag == self.selectedIndex) {
        return;
    }
    // Get the views.
    UIView * fromView = self.selectedViewController.view;
    UIView * toView = [[self.viewControllers objectAtIndex:sender.tag] view];
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = sender.tag > self.selectedIndex;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    toView.frame = CGRectMake((scrollRight ? 320 : -320), viewSize.origin.y, 320, viewSize.size.height);
    
    [UIView animateWithDuration:0.5
                     animations: ^{
                         
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake((scrollRight ? -320 : 320), viewSize.origin.y, 320, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             self.selectedIndex = sender.tag;
                         }
                     }];
    [self setSelectedIndex:sender.tag];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    
    if (selectedIndex == 0)
        [tabImageView setImage:[UIImage imageNamed:@"createSelected.png"]];
    else if (selectedIndex == 1)
        [tabImageView setImage:[UIImage imageNamed:@"findSelected.png"]];
//    else if (selectedIndex == 2)
//        [tabImageView setImage:[UIImage imageNamed:@"meSelected.png"]];
}

- (void)showTabbarImage:(BOOL)show
{
    tabImageView.hidden = !show;
}

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    int index = [self.viewControllers indexOfObject:viewController];
//    _tabSelectedView.frame = CGRectMake(index * 80.0, 0, 80.0, TABBARHEIGHT);
//
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
