//
//  UIViewController+NavigationBarTransparent.m
//  NavTransparent
//
//  Created by 李正兵 on 2017/9/26.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "UIViewController+NavigationBarTransparent.h"
#import "UINavigationBar+Transparent.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@interface UIViewController ()

@property (nonatomic, strong) UIColor *ttLastNavBarColor;

@end

@interface UINavigationBar ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation UIViewController (NavigationBarTransparent)

- (BOOL)isTransparentNavigationBar {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).boolValue;
}
- (void)setTransparentNavigationBar:(BOOL)transparentNavigationBar {
    if (self.isTransparentNavigationBar != transparentNavigationBar) {
        self.navigationBarBackgroundImageView.backgroundColor = transparentNavigationBar ? [UIColor clearColor] : self.navigationBarColor;
    }
    objc_setAssociatedObject(self, @selector(isTransparentNavigationBar), @(transparentNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)navigationBarOpaquedWithScrollOffset:(NSInteger)offset {
    self.currentOffset = offset;
    self.navigationBarBackgroundImageView.backgroundColor = self.navigationBarColor;
    [self updateNavigationBarTitleColor:nil];
    self.navigationBarBackgroundImageView.image = nil;
    if (self.isTransparentNavigationBar) {
        if (offset <= self.opaqueOffset) {
            CGFloat alpha = offset / self.opaqueOffset;
            alpha = MIN(alpha, 1);
            self.navigationBarBackgroundImageView.backgroundColor = [self.navigationBarColor colorWithAlphaComponent:alpha];
            self.navigationBarBackgroundImageView.image = self.enableNavigationBarGradient ? [UIImage imageNamed:@"navbar_gradient_shadow"] : nil;
            [self updateNavigationBarTitleColor:[self.navigationBarTitleColor colorWithAlphaComponent:alpha]];
            return NO;
        }
    }
    return YES;
}

#pragma mark -
- (BOOL)enableNavigationBarGradient {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).boolValue;
}
- (void)setEnableNavigationBarGradient:(BOOL)enableNavigationBarGradient {
    self.navigationBarBackgroundImageView.image = ((self.currentOffset <= self.opaqueOffset) && enableNavigationBarGradient) ? [UIImage imageNamed:@"navbar_gradient_shadow"] : nil;
    objc_setAssociatedObject(self, @selector(enableNavigationBarGradient), @(enableNavigationBarGradient), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -
- (CGFloat)opaqueOffset {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).floatValue ?: 64.0;
}
- (void)setOpaqueOffset:(CGFloat)opaqueOffset {
    objc_setAssociatedObject(self, @selector(opaqueOffset), @(opaqueOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)currentOffset {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).intValue;
}
- (void)setCurrentOffset:(NSInteger)currentOffset {
    objc_setAssociatedObject(self, @selector(currentOffset), @(currentOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -
- (UIImageView *)navigationBarBackgroundImageView {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if ([navigationBar respondsToSelector:@selector(backgroundImageView)]) {
        navigationBar.translucent = YES;
        return navigationBar.backgroundImageView;
    }
    return nil;
}

#pragma mark -
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL vwa = @selector(viewWillAppear:);
        SEL tctrbc_vwa = @selector(tctrbc_viewWillAppear:);
        [self swizzleInstanceSelector:vwa withNewSelector:tctrbc_vwa];
        
        SEL vwd = @selector(viewWillDisappear:);
        SEL tctrbc_vwd = @selector(tctrbc_viewWillDisappear:);
        [self swizzleInstanceSelector:vwd withNewSelector:tctrbc_vwd];
    });
}

- (void)tctrbc_viewWillAppear:(BOOL)animated {
    [self tctrbc_viewWillAppear:animated];
    if (self.tcLastNavBarColor) {
        self.navigationBarBackgroundImageView.backgroundColor = self.tcLastNavBarColor;
    }
    else if (!self.isTransparentNavigationBar) {
        self.navigationBarBackgroundImageView.backgroundColor = self.navigationBarColor;
    }
    self.enableNavigationBarGradient = self.enableNavigationBarGradient;
    [self updateNavigationBarTitleColor:self.navigationBarTitleColor];
}

- (void)tctrbc_viewWillDisappear:(BOOL)animated {
    [self tctrbc_viewWillDisappear:animated];
    self.tcLastNavBarColor = self.navigationBarBackgroundImageView.backgroundColor;
}

#pragma mark -
- (UIColor *)tcLastNavBarColor {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTcLastNavBarColor:(UIColor *)tcLastNavBarColor {
    objc_setAssociatedObject(self, @selector(tcLastNavBarColor), tcLastNavBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navigationBarColor {
    return objc_getAssociatedObject(self, _cmd) ?: self.navigationController.navigationBar.ttCustomColor;
}
- (void)setNavigationBarColor:(UIColor *)navigationBarColor {
    if (navigationBarColor) {
        self.navigationBarBackgroundImageView.backgroundColor = navigationBarColor;
    }
    objc_setAssociatedObject(self, @selector(navigationBarColor), navigationBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navigationBarTitleColor {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setNavigationBarTitleColor:(UIColor *)navigationBarTitleColor {
    [self updateNavigationBarTitleColor:navigationBarTitleColor];
    objc_setAssociatedObject(self, @selector(navigationBarTitleColor), navigationBarTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)updateNavigationBarTitleColor:(UIColor *)color {
    [self.navigationController.navigationBar ttStyle];
    NSMutableDictionary *dictionary = [self.navigationController.navigationBar.titleTextAttributes mutableCopy] ?: [NSMutableDictionary dictionary];;
    [dictionary setObject:color ?: [UIColor blackColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dictionary;
}

#pragma mark -
- (void)hideSystemBack {
    self.navigationItem.hidesBackButton = YES;
}
- (BOOL)navigationBarUserDisable {
    return self.navigationController.navigationBarHidden;
}
- (void)setNavigationBarUserDisable:(BOOL)navigationBarUserDisable {
    self.navigationController.navigationBarHidden = navigationBarUserDisable;
}

@end
