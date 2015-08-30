//
//  OneViewController.m
//  SGSideMenu
//
//  Created by 殷绍刚 on 15/8/30.
//  Copyright (c) 2015年 ysghome. All rights reserved.
//

#import "OneViewController.h"
#import "UIView+SGExtension.h"
#import "SGSideMenuClass.h"

@interface OneViewController ()

@property(strong,nonatomic) UIScrollView *contentView;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor orangeColor]];
    self.title = @"我是第一个视图";
    UIButton *_menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_menuItem setFrame:CGRectMake(0, 0, 40, 36)];
    [_menuItem setTitle:@"菜单" forState:UIControlStateNormal];
    [_menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_menuItem.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_menuItem addTarget:(SGNavigationController *)self.navigationController action:@selector(showMenuView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_menuItem];
    
    /**
     *  测试滚动视图的效果 侧滑效果
     */
    self.contentView = [[UIScrollView alloc] init];
    [self.contentView setFrame:CGRectMake(0, 0, self.view.sg_width, self.view.sg_height)];
    [self.view addSubview:self.contentView];
    [self.contentView setContentSize:CGSizeMake(self.contentView.sg_width*3, self.contentView.sg_height)];
    
    UIView *vi1 = [[UIView alloc] initWithFrame:self.contentView.bounds];
    vi1.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:vi1];
    
    UIView *vi2 = [[UIView alloc] initWithFrame:CGRectMake(vi1.sg_right, 0, self.contentView.sg_width, self.contentView.sg_height)];
    [vi2 setBackgroundColor:[UIColor redColor]];
    [self.contentView addSubview:vi2];
    
    UIView *vi3 = [[UIView alloc] initWithFrame:CGRectMake(vi2.sg_right, 0, self.contentView.sg_width, self.contentView.sg_height)];
    [vi3 setBackgroundColor:[UIColor blackColor]];
    [self.contentView addSubview:vi3];
    
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
