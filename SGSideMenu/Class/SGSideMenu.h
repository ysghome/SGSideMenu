//
//  SGSideMenu.h
//  SGSideMenu
//
//  Created by 殷绍刚 on 15/8/30.
//  Copyright (c) 2015年 ysghome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGFrostedSidebar;

@interface SGSideMenu : UIViewController

@property(nonatomic,strong)SGFrostedSidebar *LeftVC;
@property(nonatomic,strong)UIViewController *MainVC;

@property(nonatomic,strong)NSMutableDictionary *controllersDict;

@property (strong, nonatomic,readonly) UIPanGestureRecognizer *panGestureRec;


@property(nonatomic,strong) NSString *selectClassName;
@property(nonatomic,assign)float leftSCloseDuration;
@property(nonatomic,assign)BOOL canShowLeft;
/**控制主视图显示*/
- (void)showContentControllerWithModel:(NSString*)className;
- (void)showLeftViewController;
- (void)refreshView;

/**移除不需要的控制器*/
- (void)removeContentControllerWithModel:(NSString*)className;
/**清除所有的控制器,除哪个以为*/
- (void)removeContentControllerAllsExceptName:(NSString *)className;

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes;
- (void)closeSideBar;

+ (SGSideMenu *)sharedSideMenu;

@end
