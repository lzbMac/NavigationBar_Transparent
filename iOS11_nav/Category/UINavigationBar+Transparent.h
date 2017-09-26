//
//  UINavigationBar+Transparent.h
//  NavTransparent
//
//  Created by 李正兵 on 2017/9/26.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (TTStyle)

/** 自定义NavigationBar样式
 UINavigationController创建自动调用
 特殊情况手动掉用
 建议在-viewDidAppear调用*/
- (void)ttStyle;

/** 项目自定义Bar颜色 */
- (UIColor *)ttCustomColor;
/** 项目自定义Bar标题颜色 */
- (UIColor *)ttCustomTitleColor;

@end
