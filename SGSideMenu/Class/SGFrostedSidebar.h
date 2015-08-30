//
//  SGFrostedSidebar.h
//  SGSideMenu
//
//  Created by 殷绍刚 on 15/8/30.
//  Copyright (c) 2015年 ysghome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGFrostedSidebar;

@protocol SGFrostedSidebarDelegate <NSObject>

- (void)sgFrostedSidebarWithDidSelectClassName:(NSString *)aClassName;

@end

@interface SGFrostedSidebar : UIViewController

@property (nonatomic,assign) id<SGFrostedSidebarDelegate> delegate;
@property (nonatomic,strong) UITableView *tableView;

/**加载菜单数据*/
- (void)loadData;

@end
