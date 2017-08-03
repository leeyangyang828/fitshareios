//
//  RepsEditCell.h
//  FitNectApp
//
//  Created by stepanekdavid on 11/9/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepsEditCell : UITableViewCell
{
}
@property (nonatomic, retain) NSDictionary *curDict;
+ (RepsEditCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSString *)rep;

@property (weak, nonatomic) IBOutlet UILabel *lblOneSet;
@property (weak, nonatomic) IBOutlet UITextField *txtOneSet;


@end
