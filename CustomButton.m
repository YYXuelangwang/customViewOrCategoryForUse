

#import "CustomButton.h"

@implementation CustomButton

+ (instancetype)centertitleButtonWithImageName:(NSString *)imageName titleName:(NSString *)title {
    
    CustomButton *centerTitleBtn = [[self alloc] init];
    
    centerTitleBtn.imageName = imageName;
    centerTitleBtn.title = title;
    
    return centerTitleBtn;
    
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return self;
    
}

//UIButton自带的方法可以调整image的尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat x = contentRect.size.width * 0.2;
    CGFloat y = contentRect.size.height * 0.2;
    CGFloat w = contentRect.size.width - x * 2;
    CGFloat h = contentRect.size.height * 0.5;
    CGRect rect = CGRectMake(x, y, w, h);
    
    return rect;
}

//UIButton自带的方法可以根据contentRect来调整Label的尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat x = 0;
    CGFloat y = contentRect.size.height * 0.65;
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height * 0.3;
    
    CGRect rect = CGRectMake(x, y, w, h);
    
    return rect;
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setImageName:(NSString *)imageName {
    
    _imageName = imageName;
    
    
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
