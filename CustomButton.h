

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

@property (nonatomic,strong) NSString *imageName;

@property (nonatomic,strong) NSString *title;

+ (instancetype)centertitleButtonWithImageName:(NSString *)imageName titleName:(NSString *)title;

@end
