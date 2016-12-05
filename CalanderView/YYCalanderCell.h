//
//  YYCalanderCell.h
//  testCalendar
//
//  Created by 钱范儿-Developer on 16/11/8.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const YYCALANDERCELL_BUTTONCLICKED_NOTIFICATION;
extern NSString *const USERINFO_BUTTON_FRAME_KEY;
extern NSString *const USERINFO_SELECTED_DATE_KEY;
extern NSString *const USERINFO_ITEM_KEY;

@interface YYCalanderCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *calcuteDate;

- (void)chooseFirstDayButton;

@end
