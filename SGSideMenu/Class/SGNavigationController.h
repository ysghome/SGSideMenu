//
//  SGNavigationController.h
//  SGSideMenu
//
//  Created by 殷绍刚 on 15/8/30.
//  Copyright (c) 2015年 ysghome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGSideMenu;

@interface UIViewController (SGSideMenu)

@property (strong, readonly, nonatomic) SGSideMenu *SideMenu;

@end

@interface SGNavigationController : UINavigationController

- (void)showMenuView;

@end
