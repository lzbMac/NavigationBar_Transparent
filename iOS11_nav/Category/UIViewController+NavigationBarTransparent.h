//
//  UIViewController+NavigationBarTransparent.h
//  NavTransparent
//
//  Created by 李正兵 on 2017/9/26.
//  Copyright © 2017年 李正兵. All rights reserved.
//
//  渐变不支持iOS7系统滑动返回

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBarTransparent)

/** NavBar完全透明，只在设置为YES的ViewController有效，默认为NO */
@property (nonatomic, assign, getter=isTransparentNavigationBar) BOOL transparentNavigationBar;

/** Bar首次展示带阴影，默认NO */
@property (nonatomic, assign) BOOL enableNavigationBarGradient;

/** Bar颜色改变的偏移高度，默认64 */
@property (nonatomic, assign) CGFloat opaqueOffset;

/** 自定义导航栏颜色 */
@property (nonatomic, strong) UIColor *navigationBarColor;

/** 自定义导航栏标题颜色 */
@property (nonatomic, strong) UIColor *navigationBarTitleColor;

/**
 *  根据滑动的偏移渐变NavigationBar的颜色，由透明转变为白色
 *
 *  @param offset 已经滑动的便宜，可设置为scrollView.contentOffset.y
 *
 *  @return 滑动是否已经超过opaqueOffset达到预期效果，返回YES表示完全不透明
 */
- (BOOL)navigationBarOpaquedWithScrollOffset:(NSInteger)offset;

/** navigationBar透明状态点击可穿过 */
@property (nonatomic, assign) BOOL navigationBarUserDisable DEPRECATED_MSG_ATTRIBUTE("设置navigationController.navigationBarHidden");
/** 去除页面自带的返回按钮，禁止使用hidesBackButton，使用此方法替代 */
- (void)hideSystemBack DEPRECATED_MSG_ATTRIBUTE("设置navigationItem.hidesBackButton");

@end
