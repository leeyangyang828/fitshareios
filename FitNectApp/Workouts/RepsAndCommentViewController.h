//
//  RepsAndCommentViewController.h
//  FitNectApp
//
//  Created by stepanekdavid on 11/9/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepsAndCommentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

    __weak IBOutlet UILabel *lblExercise;
    __weak IBOutlet UITableView *RepsTableview;
    __weak IBOutlet UIView *CommentView;
    __weak IBOutlet UITextView *txtComments;
}
- (IBAction)onSave:(id)sender;

@property (nonatomic, retain) NSMutableDictionary *arrWorkoutsCreated;
@property (nonatomic, retain) NSString *exercise;
@property (nonatomic, retain) NSString *sets;
@end
