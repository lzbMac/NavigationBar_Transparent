//
//  ViewController.m
//  iOS11_nav
//
//  Created by 李正兵 on 2017/9/19.
//  Copyright © 2017年 李正兵. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationBar+Transparent.h"
#import "UIViewController+NavigationBarTransparent.h"
#import "Test2ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIView *left2View;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configNavigation];
    
    self.navigationBarColor = [UIColor cyanColor];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationBarColor = [UIColor blueColor];
}
- (void)configNavigation {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"工作台" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftView];
    UIBarButtonItem *backItem2 = [[UIBarButtonItem alloc] initWithCustomView:self.btnBack];
    self.navigationItem.leftBarButtonItems = @[backItem,backItem2];

}
- (IBAction)pop:(id)sender {
    NSLog(@"pop________________pop");
}
- (IBAction)action:(id)sender {
    NSLog(@"天天爱车---------------");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor cyanColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (IBAction)test2:(id)sender {
    Test2ViewController *vc = [[Test2ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
