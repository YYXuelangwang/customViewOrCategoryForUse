//
//  RollingNumView.h
//  GetBuryingData
//
//  Created by langwang on 24/8/2020.
//  Copyright © 2020 qufan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RollingNumView : UIView
@property (assign, nonatomic) CGSize  itemSize;
@property (assign, nonatomic) CGFloat  itemSpace;
@property (strong, nonatomic) NSString  *orignNumStr;
/** 前一段图片名 */
@property (strong, nonatomic) NSString  *preImageName;
- (void)updateValueWithAnimation:(NSString*)valueStr;
@end

NS_ASSUME_NONNULL_END
