//
//  Test2ViewController.m
//  iOS11_nav
//
//  Created by 李正兵 on 2017/9/26.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "Test2ViewController.h"
#import "UIViewController+NavigationBarTransparent.h"
#import "Test1ViewController.h"

@interface Test2ViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray * titles;
@property (nonatomic, strong)NSArray * colors;

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"Test2";
    self.transparentNavigationBar = YES;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _titles = @[@"红色",@"紫色",@"蓝色",@"绿色",@"不设置颜色",@"灰色",@"随机颜色1",@"随机颜色2",@"随机颜色3",@"随机颜色4",@"随机颜色5"];
    _colors = @[[UIColor redColor],[UIColor purpleColor],[UIColor blueColor],[UIColor greenColor],[NSNull null], [UIColor grayColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor]];

    NSLayoutConstraint *widC = [NSLayoutConstraint constraintWithItem:self.btnBack attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:44.0];
    
    NSLayoutConstraint *heiC = [NSLayoutConstraint constraintWithItem:self.btnBack attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:40.0];
    
    [_btnBack addConstraints:@[widC, heiC]];
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnBack];
//    self.navigationController.navigationBarHidden = YES;
    UIImage *back = [UIImage imageNamed:@"back"];
    [self.btnBack setImage:[self imageWithTintColor:[UIColor whiteColor] blendMode:kCGBlendModeOverlay img:back] forState:UIControlStateNormal];
    
    self.opaqueOffset = 88.0;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.enableNavigationBarGradient = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [self randomColor];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row-----%@-------", @(indexPath.row));
    Test1ViewController *test = [[Test1ViewController alloc] init];
    UIColor *navColor = _colors[indexPath.row];
    if ([navColor isKindOfClass:[UIColor class]]) {
//        test.navigationBarColor = navColor;
    }
    [self.navigationController pushViewController:test animated:YES];
}
- (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)popBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    
    BOOL  isOpque = [self navigationBarOpaquedWithScrollOffset:offset];
    if (!isOpque) {
        UIImage *back = [UIImage imageNamed:@"back"];
        [self.btnBack setImage:[self imageWithTintColor:[UIColor whiteColor] blendMode:kCGBlendModeOverlay img:back] forState:UIControlStateNormal];
    }else {
        [self.btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode img:(UIImage *)img

{
    
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0f);
    
    [tintColor setFill];
    
    CGRect bounds = CGRectMake(0, 0, img.size.width, img.size.height);
    
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    
    [img drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        
        [img drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
        
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tintedImage;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
