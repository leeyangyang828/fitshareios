//
//  WorkOutsCell.m
//  FitNect
//
//  Created by stepanekdavid on 7/26/16.
//  Copyright © 2016 jella. All rights reserved.
//

#import "WorkOutsCell.h"
#import "SKSTableViewCellIndicator.h"
#define kIndicatorViewTag -1
@implementation WorkOutsCell
+ (WorkOutsCell *)sharedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WorkOutsCell" owner:nil options:nil];
    WorkOutsCell *cell = [array objectAtIndex:0];
    
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCurWorkoutsItem:(NSString *)workoutsItem
{
    _curDict = workoutsItem;
}

- (IBAction)onComments:(id)sender {
    [_resDelegate didComments:_curDict];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(13, 35, 26, 12);
    
    if (self.isExpanded) {
        [self.imageView setImage:[UIImage imageNamed:@"up.png"]];
        if (![self containsIndicatorView])
            [self addIndicatorView];
        else {
            [self removeIndicatorView];
            [self addIndicatorView];
        }
    }else{
        [self.imageView setImage:[UIImage imageNamed:@"down.png"]];
    }
}

static UIImage *_image = nil;
- (UIView *)expandableView
{
    if (!_image) {
        _image = [UIImage imageNamed:@"up.png"];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(13, 35, 30, 12);
    button.frame = frame;
    
    [button setBackgroundImage:_image forState:UIControlStateNormal];
    
    return button;
}

- (void)setExpandable:(BOOL)isExpandable
{
    if (isExpandable){
        //[self.imageView setImage:[UIImage imageNamed:@"small_logo_gray.png"]];
        //[self.contentView addSubview:[self expandableView]];
    }
    
    _expandable = isExpandable;
}


- (void)addIndicatorView
{
    CGPoint point = self.accessoryView.center;
    CGRect bounds = self.accessoryView.bounds;
    
    CGRect frame = CGRectMake((point.x - CGRectGetWidth(bounds) * 1.5), point.y * 1.4, CGRectGetWidth(bounds) * 3.0, CGRectGetHeight(self.bounds) - point.y * 1.4);
    SKSTableViewCellIndicator *indicatorView = [[SKSTableViewCellIndicator alloc] initWithFrame:frame];
    indicatorView.tag = kIndicatorViewTag;
    [self.contentView addSubview:indicatorView];
}

- (void)removeIndicatorView
{
    id indicatorView = [self.contentView viewWithTag:kIndicatorViewTag];
    if (indicatorView)
    {
        [indicatorView removeFromSuperview];
        indicatorView = nil;
    }
}

- (BOOL)containsIndicatorView
{
    return [self.contentView viewWithTag:kIndicatorViewTag] ? YES : NO;
}

- (void)accessoryViewAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isExpanded) {
            //[_imgCityAndFood setImage:[UIImage imageNamed:@"small_logo_green.png"]];
            self.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
            [self.imageView setImage:[UIImage imageNamed:@"down.png"]];
        } else {
            //[_imgCityAndFood setImage:[UIImage imageNamed:@"small_logo_gray.png"]];
            self.accessoryView.transform = CGAffineTransformMakeRotation(0);
            [self.imageView setImage:[UIImage imageNamed:@"up.png"]];
        }
    } completion:^(BOOL finished) {
        
        if (!self.isExpanded)
            [self removeIndicatorView];
        
    }];
}
@end
