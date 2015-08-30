//
//  SGFrostedSidebar.m
//  SGSideMenu
//
//  Created by 殷绍刚 on 15/8/30.
//  Copyright (c) 2015年 ysghome. All rights reserved.
//

#import "SGFrostedSidebar.h"
#import "SGSideMenuConst.h"
#import "UIView+SGExtension.h"
#import "SGSideMenu.h"
#import "SGFrostedSidebarCell.h"

@interface SGFrostedSidebar ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  存放图片和类名数据
 */
@property (nonatomic, strong) NSMutableArray *imgAndClassName;

@end

@implementation SGFrostedSidebar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SGLeftSideMenuWidthL, self.view.sg_height)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBounces:NO];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftBottombackView.png"]]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
    
    [self loadData];
}

- (void)loadData{
    if (!_imgAndClassName)
        _imgAndClassName = [[NSMutableArray alloc] initWithCapacity:0];
    
    [_imgAndClassName removeAllObjects];
    
    NSMutableArray *array1 = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    [array1 addObject:@{@"icon":[UIImage imageNamed:[NSString stringWithFormat:@"IconHome"]],@"title":@"Home",@"class":@"OneViewController"}];
    
    [array1 addObject:@{@"icon":[UIImage imageNamed:[NSString stringWithFormat:@"IconProfile"]],@"title":@"Profile",@"class":@"TwoViewController"}];

    [array1 addObject:@{@"icon":[UIImage imageNamed:[NSString stringWithFormat:@"IconCalendar"]],@"title":@"Calendar",@"class":@"ThereViewController"}];
    
    NSArray *array2 = @[@{@"icon":[UIImage imageNamed:[NSString stringWithFormat:@"IconSettings"]],@"title":@"Settings",@"class":@"FourViewController"}];
    
    [_imgAndClassName addObject:array1];
    [_imgAndClassName addObject:array2];
    
    [_tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    /**
     *  这里是设置菜单的间隔的
     */
    if (sectionIndex == 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.sg_width, 80)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    
    if (sectionIndex == 1){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.sg_width, 150)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 80;
    }
    
    if (section == 1){
        return 150;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_imgAndClassName count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_imgAndClassName objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *aCell =@"cell";
    SGFrostedSidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:aCell];
    if (!cell) {
        cell = [[SGFrostedSidebarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aCell];
        UIView *selectedBackgroundView=[[UIView alloc] initWithFrame:cell.frame];
        [selectedBackgroundView setBackgroundColor:SGGetColor(130, 195, 39, 1)];
        cell.selectedBackgroundView = selectedBackgroundView;
    }
    UIImage *tempImag = [[[_imgAndClassName objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"icon"];
    if([[[[_imgAndClassName objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"class"] isEqualToString:[SGSideMenu sharedSideMenu].selectClassName]){
        cell.backgroundColor =SGGetColor(130, 195, 39, 1);
    }
    else{
        cell.backgroundColor =[UIColor clearColor];
    }
    
    cell.backImageView.image = tempImag;
    cell.backLabel.text = [[[_imgAndClassName objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //传值
    NSString *selectClassName = [[[_imgAndClassName objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"class"];
    if ([self.delegate respondsToSelector:@selector(sgFrostedSidebarWithDidSelectClassName:)]) {
       [self.delegate sgFrostedSidebarWithDidSelectClassName:selectClassName];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [_tableView setFrame:CGRectMake(0, 0, SGLeftSideMenuWidthL, self.view.sg_height)];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
