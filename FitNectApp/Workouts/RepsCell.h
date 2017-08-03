//
//  RepsCell.h
//  FitNectApp
//
//  Created by stepanekdavid on 11/2/16.
//  Copyright © 2016 lovisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepsCell : UITableViewCell
{
}
@property (nonatomic, retain) NSDictionary *curDict;
+ (RepsCell *)sharedCell;
- (void)setCurWorkoutsItem:(NSString *)rep;
@property (weak, nonatomic) IBOutlet UILabel *lblRep;
@property (weak, nonatomic) IBOutlet UILabel *lblNameRep;



@end
