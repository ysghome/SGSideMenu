//
//  SGSideMenu.m
//  SGSideMenu
//
//  Created by 殷绍刚 on 15/8/30.
//  Copyright (c) 2015年 ysghome. All rights reserved.
//

#import "SGSideMenu.h"
#import "SGFrostedSidebar.h"
#import "SGNavigationController.h"
#import "UIView+SGExtension.h"
#import "SGSideMenuConst.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGestureRecognizerSubclass.h>


/**
 *  这里需要自定义一个手势
 */

@interface SGPanGestureRecognizer : UIPanGestureRecognizer
@property (readonly, nonatomic) UIEvent *event;
@end

@interface SGPanGestureRecognizer ()
@property (strong, nonatomic) UIEvent *event;
@end

@implementation SGPanGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.event = event;
    [super touchesBegan:touches withEvent:event];
}

- (void)reset
{
    self.event = nil;
    [super reset];
}

@end


static SGSideMenu *_sharedMenu;

@interface SGSideMenu ()<SGFrostedSidebarDelegate,UIGestureRecognizerDelegate>{
    UIView *_mainContentView;
    UIView *_leftSideView;
    UIView *_leftBackGroundView;
    
    UITapGestureRecognizer *_tapGestureRec;
    UIPanGestureRecognizer *_panGesture;
    
    NSMutableDictionary *_controllersDict;
    
    BOOL showingLeft;
    
    CGPoint leftOrigin;
}
/**
 *  语句块中使用，避免内存泄露
 */
@property(nonatomic)SGSideMenu *weakSelf;

@end

@implementation SGSideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _weakSelf = self;
    
    _controllersDict = [[NSMutableDictionary alloc] init];
    
    [self initSubviews];
    if (!_LeftVC) {
        _LeftVC = [[SGFrostedSidebar alloc] init];
    }
    [self initChildControllers:_LeftVC];
    
    [self showContentControllerWithModel:_MainVC!=nil?NSStringFromClass([_MainVC class]):@"OneViewController"];//设置主菜单
    
    
    _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];//关闭左边的菜单
    [_leftBackGroundView addGestureRecognizer:_tapGestureRec];
    _tapGestureRec.enabled = NO;
    _panGesture = [[SGPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [_leftBackGroundView addGestureRecognizer:_panGesture];
    _panGesture.enabled = NO;
    
    _panGestureRec = [[SGPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [_panGestureRec setDelegate:self];
    [_mainContentView addGestureRecognizer:_panGestureRec];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSArray *keys =[_controllersDict allKeys];
    for (int i=0; i<keys.count; i++) {//移除多余的子视图控制器
        SGNavigationController *tempNav = [_controllersDict objectForKey:[keys objectAtIndex:i]];
        SGNavigationController *selectNav =_controllersDict[self.selectClassName];
        if (selectNav != tempNav) {
            [tempNav removeFromParentViewController];
            [_controllersDict removeObjectForKey:[keys objectAtIndex:i]];
        }
    }
}

+ (SGSideMenu *)sharedSideMenu{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMenu = [[self alloc] init];
    });
    return _sharedMenu;
}

- (float)leftSCloseDuration{
    if (!_leftSCloseDuration) {
        _leftSCloseDuration = .3f;
    }
    return _leftSCloseDuration;
}

-(void)dealloc{
    _mainContentView = nil;
    _leftSideView = nil;
    
    _controllersDict = nil;
    
    _tapGestureRec = nil;
    _panGestureRec = nil;
    
    _LeftVC = nil;
    _MainVC = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Init

- (void)initSubviews
{
    
     _leftSideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.sg_width, self.view.sg_height)];
    [self.view addSubview:_leftSideView];
    [_leftSideView setBackgroundColor:SGGetColor(0, 0, 0, 0)];
    
    _leftBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(SGLeftSideMenuWidthL, 0, _leftSideView.sg_width - SGLeftSideMenuWidthL, _leftSideView.sg_height)];
    [_leftSideView addSubview:_leftBackGroundView];
    [_leftBackGroundView setBackgroundColor:[UIColor clearColor]];
    
    _mainContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.sg_width, self.view.sg_height)];
    [self.view addSubview:_mainContentView];
}

- (void)initChildControllers:(SGFrostedSidebar *)leftVC
{
    if (leftVC != nil) {
        [self addChildViewController:leftVC];
        if ([[leftVC class] isSubclassOfClass:[SGFrostedSidebar class]]) {
            _LeftVC.delegate = self;
        }
        leftVC.view.frame=CGRectMake(0, 0, SGLeftSideMenuWidthL, self.view.sg_height);
        [_leftSideView addSubview:leftVC.view];
    }
    //隐藏左边的视图
    [_leftSideView setHidden:YES];
}

#pragma mark - Actions
/**切换主视图显示的视图**/
- (void)showContentControllerWithModel:(NSString *)className
{
    //隐藏侧滑菜单
    [self closeSideBar];
    
    if ([self.selectClassName isEqual:className]) {
        return;
    }
    
    // 1.从字典中取出即将要显示的子控制器
    SGNavigationController *nav = _controllersDict[className];
    NSArray *keys =[_controllersDict allKeys];
    for (int i=0; i<keys.count; i++) {//移除多余的子视图控制器
        SGNavigationController *tempNav = [_controllersDict objectForKey:[keys objectAtIndex:i]];
        if (nav != tempNav) {
            [tempNav removeFromParentViewController];
        }
    }
    
    if (!nav)
    {
        Class c = NSClassFromString(className);
        if(!c)return;
        
        UIViewController *vc = [[c alloc] init];
        
        nav = [[SGNavigationController alloc] initWithRootViewController:vc];
        
        nav.view.autoresizingMask = UIViewAutoresizingNone;
        //是否透明
        [nav.navigationBar setTranslucent:NO];
        
        [self addChildViewController:nav];
        [_controllersDict setObject:nav forKey:className];
    }else{
        [self addChildViewController:nav];
    }
    
    if (_mainContentView.subviews.count > 0)
    {
        UIView *view = [_mainContentView.subviews firstObject];
        [view removeFromSuperview];
    }
    
    if (self.MainVC == nav) return;
    
    // 2.移除旧控制器的view
    [self.MainVC.view removeFromSuperview];
    
    CGFloat width = self.view.sg_width;
    CGFloat height = self.view.sg_height;
    nav.view.frame = CGRectMake(0, 0, width, height);
    [_mainContentView addSubview:nav.view];
    
    self.MainVC = nav;
    self.selectClassName = className;
    [_LeftVC.tableView reloadData];
}

/**移除不需要的控制器*/
- (void)removeContentControllerWithModel:(NSString*)className{
    Class c = NSClassFromString(className);
    if (c) {
        SGNavigationController *tempNav = [_controllersDict objectForKey:className];
        SGNavigationController *selectNav;
        if (self.selectClassName !=nil) {
            selectNav =_controllersDict[self.selectClassName];
        }
        if (tempNav) {//移除控制器
            [tempNav removeFromParentViewController];
            [_controllersDict removeObjectForKey:className];
        }
        if (selectNav == tempNav) {//移除view
            [tempNav.view removeFromSuperview];
            self.selectClassName = nil;
        }
    }
}
/**清除所有的控制器,除哪个以为*/
- (void)removeContentControllerAllsExceptName:(NSString *)className{
    NSArray *keys =[_controllersDict allKeys];
    for (int i=0; i<keys.count; i++) {//移除多余的子视图控制器
        NSString *tempKey = [keys objectAtIndex:i];
        if (![tempKey isEqualToString:className]) {
            SGNavigationController *tempNav = [_controllersDict objectForKey:tempKey];
            SGNavigationController *selectNav;
            if (self.selectClassName !=nil) {
                selectNav =_controllersDict[self.selectClassName];
            }
            
            [tempNav removeFromParentViewController];
            [_controllersDict removeObjectForKey:tempKey];
            if (selectNav == tempNav) {
                [tempNav.view removeFromSuperview];
                self.selectClassName = nil;
            }
        }
    }
    
}


/**实现选择的委托**/
- (void)sgFrostedSidebarWithDidSelectClassName:(NSString *)aClassName{
    NSLog(@"选择却换的类名是 %@",aClassName);
    
    Class c = NSClassFromString(aClassName);
    
    if (c) {
        [self showContentControllerWithModel:aClassName];
    }
}

- (void)closeSideBar
{
    [UIView animateWithDuration:self.leftSCloseDuration animations:^{
        CGRect leftRect = CGRectMake(-SGLeftSideMenuWidthL, 0, SGLeftSideMenuWidthL, _weakSelf.view.sg_height);
        [_weakSelf.LeftVC.view setFrame:leftRect];
        [_leftSideView setBackgroundColor:SGGetColor(0, 0, 0, 0)];
    } completion:^(BOOL finished) {
        if (finished) {
            [_weakSelf.view sendSubviewToBack:_leftSideView];
            _panGesture.enabled = NO;
            _tapGestureRec.enabled = NO;
            [_leftSideView setHidden:YES];
        }
    }];
    self.canShowLeft = NO;
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes
{
    CGPoint point = [panGes translationInView:_mainContentView];
    
    CGRect leftFrame = self.LeftVC.view.frame;
    
    if (panGes.state == UIGestureRecognizerStateBegan)
    {
        leftOrigin= self.LeftVC.view.frame.origin;
    }
    
    if (panGes.state == UIGestureRecognizerStateChanged)
    {
        if (point.x>=0) {//向右滑动
            [self.view sendSubviewToBack:_mainContentView];
            [_leftSideView setHidden:NO];
            if (self.LeftVC.view.frame.origin.x <= 0) {
                leftFrame.origin.x = leftOrigin.x + point.x;
            }
            if (leftFrame.origin.x >= 0)
                leftFrame.origin.x = 0;
        }
        else{//向左滑动
            if (self.LeftVC.view.frame.origin.x >= -SGLeftSideMenuWidthL) {
                leftFrame.origin.x = leftOrigin.x + point.x;
            }
            if (leftFrame.origin.x <= -SGLeftSideMenuWidthL)
                leftFrame.origin.x = -SGLeftSideMenuWidthL;
        }
        self.LeftVC.view.frame = leftFrame;
    }
    else if (panGes.state == UIGestureRecognizerStateEnded)
    {
        if ([panGes velocityInView:_mainContentView].x <= 0) {
            [self closeSideBar];
        } else {
            [self showLeft];
        }
    }
}

#pragma mark - 手势委托
- (BOOL)gestureRecognizer:(SGPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    // 如果是scrollview 判断scrollview contentOffset 是否为0，是 cancel scrollview 的手势，否cancel自己
    if ([[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)[otherGestureRecognizer view];
        UIPanGestureRecognizer *fd_otherGestureRecognizer = (UIPanGestureRecognizer *)otherGestureRecognizer;
        if (scrollView.contentOffset.x <= 0 && fd_otherGestureRecognizer) {
            NSSet *touchs = [gestureRecognizer.event touchesForGestureRecognizer:otherGestureRecognizer];
            [otherGestureRecognizer touchesCancelled:touchs withEvent:gestureRecognizer.event];
            
            return YES;
        }
    }
    return NO;
}


- (void)showLeft{
    [self.view bringSubviewToFront:_leftSideView];
    [self.view sendSubviewToBack:_mainContentView];
    
    [_leftSideView setHidden:NO];
    
    [UIView animateWithDuration:self.leftSCloseDuration animations:^{
        CGRect leftRect = CGRectMake(0, 0, SGLeftSideMenuWidthL, _weakSelf.view.sg_height);
        [_weakSelf.LeftVC.view setFrame:leftRect];
    } completion:^(BOOL finished) {
        if (finished) {
            [_leftSideView setBackgroundColor:SGGetColor(0, 0, 0, .35)];
            _tapGestureRec.enabled = YES;
            _panGesture.enabled = YES;
        }
    }];
    self.canShowLeft = YES;
}

- (void)showLeftViewController{
    
    if (self.canShowLeft) {//已经打开菜单
        [self closeSideBar];
    }else{
        [self showLeft];
    }
}

/**刷新视图*/
- (void)refreshView{
    if (self.selectClassName) {
        // 1.从字典中取出即将要显示的子控制器
        SGNavigationController *nav = _controllersDict[_selectClassName];
        NSArray *keys =[_controllersDict allKeys];
        for (int i=0; i<keys.count; i++) {//移除多余的子视图控制器
            SGNavigationController *tempNav = [_controllersDict objectForKey:[keys objectAtIndex:i]];
            [tempNav removeFromParentViewController];
        }
        
        [self addChildViewController:nav];
        
        if (_mainContentView.subviews.count > 0)
        {
            UIView *view = [_mainContentView.subviews firstObject];
            [view removeFromSuperview];
        }
        
        //NSLog(@"进行了视图的刷新.....");
        
        // 2.移除旧控制器的view
        [self.MainVC.view removeFromSuperview];
        
        CGFloat width = self.view.sg_width;
        CGFloat height = self.view.sg_height;
        nav.view.frame = CGRectMake(0, 0, width, height);
        [_mainContentView addSubview:nav.view];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [_mainContentView setFrame:CGRectMake(0, 0, self.view.sg_width, self.view.sg_height)];
    
    [self.MainVC.view setFrame:_mainContentView.frame];
    
    [_leftSideView setFrame:CGRectMake(0, 0, self.view.sg_width, self.view.sg_height)];
    
    [_leftBackGroundView setFrame:CGRectMake(SGLeftSideMenuWidthL, 0, self.view.sg_width - SGLeftSideMenuWidthL, self.view.sg_height)];
    CGRect leftRect;
    if (!self.canShowLeft) {
        leftRect = CGRectMake(-SGLeftSideMenuWidthL, 0, SGLeftSideMenuWidthL, self.view.sg_height);
    }
    else{
        leftRect = CGRectMake(0, 0, SGLeftSideMenuWidthL, self.view.sg_height);
    }
    [self.LeftVC.view setFrame:leftRect];
}


- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}


@end
