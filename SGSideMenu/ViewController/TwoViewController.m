//
//  TwoViewController.m
//  SGSideMenu
//
//  Created by 殷绍刚 on 15/8/30.
//  Copyright (c) 2015年 ysghome. All rights reserved.
//

#import "TwoViewController.h"
#import "SGSideMenuClass.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor cyanColor]];
    self.title = @"我是我是个人视图";
    UIButton *_menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_menuItem setFrame:CGRectMake(0, 0, 40, 36)];
    [_menuItem setTitle:@"菜单" forState:UIControlStateNormal];
    [_menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_menuItem.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_menuItem addTarget:(SGNavigationController *)self.navigationController action:@selector(showMenuView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_menuItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
