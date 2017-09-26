//
//  UINavigationBar+Transparent.m
//  NavTransparent
//
//  Created by 李正兵 on 2017/9/26.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "UINavigationBar+Transparent.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@interface UINavigationBar ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong, readonly) UIColor *ttCustomColor;

@end

@implementation UINavigationBar (TTStyle)

- (UIColor *)ttCustomColor {//0xf9f9f9
    return [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
}
- (UIColor *)ttCustomTitleColor {//0x333333
    return [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
}

- (void)ttStyle {
    CGRect superRect = self.subviews.firstObject.frame;
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect rect = CGRectMake(0, 0, screenRect.size.width, superRect.size.height);
    if (!self.backgroundImageView) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:rect];
        self.backgroundImageView.backgroundColor = self.ttCustomColor;
        self.backgroundImageView.userInteractionEnabled = NO;
        [self.subviews.firstObject addSubview:self.backgroundImageView];
    }
    self.backgroundImageView.frame = rect;
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = UIImage.new;
    self.barStyle = UIBarStyleDefault;
    self.translucent = YES;
    
    NSMutableDictionary *dictionary = [self.titleTextAttributes mutableCopy] ?: [NSMutableDictionary dictionary];;
    [dictionary setObject:self.ttCustomTitleColor forKey:NSForegroundColorAttributeName];
    [dictionary setObject:[UIFont boldSystemFontOfSize:(18.f)] forKey:NSFontAttributeName];
    [dictionary setObject:({
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor clearColor]; shadow;
    }) forKey:NSShadowAttributeName];
    self.titleTextAttributes = dictionary;
}

- (UIImageView *)backgroundImageView {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setBackgroundImageView:(UIImageView *)backgroundImageView {
    objc_setAssociatedObject(self, @selector(backgroundImageView), backgroundImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UINavigationController (TTStyle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL vwa = @selector(viewWillAppear:);
        SEL ttstyle_vwa = @selector(ttstyle_viewWillAppear:);
        [self swizzleInstanceSelector:vwa withNewSelector:ttstyle_vwa];
        
        SEL vda = @selector(viewDidAppear:);
        SEL ttstyle_vda = @selector(ttstyle_viewDidAppear:);
        [self swizzleInstanceSelector:vda withNewSelector:ttstyle_vda];
    });
}

- (void)ttstyle_viewWillAppear:(BOOL)animated {
    [self ttstyle_viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)ttstyle_viewDidAppear:(BOOL)animated {
    [self ttstyle_viewDidAppear:animated];
    if ([self isMemberOfClass:[UINavigationController class]]) {
        [self.navigationBar ttStyle];
    }
}

@end
