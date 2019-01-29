//
//  PassWordView.h
//  PassWord
//
//  Created by 钱范儿-Developer on 16/7/18.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPassWordView;

@protocol YYPassWordViewDelegate <NSObject>

@optional

- (void)passWordViewInputPassWordFailed:(YYPassWordView*)passWordView ;

- (void)passWordViewInputPassWordSuccessed:(YYPassWordView*)passWordView;

@end

@interface YYPassWordView : UIView

@property (nonatomic, strong) NSString *passWord;

@property (nonatomic, weak) id<YYPassWordViewDelegate> delegate;

- (instancetype)initWithPassWord:(NSString*)passWord;

@end


typedef void(^HandleEventAfterTouch)(NSInteger number);

@interface YYCircleView : UIView

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, getter = isLighted) BOOL lighted;

@property (nonatomic, getter = isHasNumber) BOOL hasNumber;

@property (nonatomic, assign) BOOL touchLighted;

@property (nonatomic, strong) HandleEventAfterTouch touchEvent;

@end