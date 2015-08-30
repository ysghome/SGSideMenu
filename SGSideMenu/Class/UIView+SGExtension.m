//
//  UIView+SGExtension.m
//  SGSideMenu
//
//  Created by 殷绍刚 on 15/8/30.
//  Copyright (c) 2015年 ysghome. All rights reserved.
//

#import "UIView+SGExtension.h"

@implementation UIView (SGExtension)

- (CGFloat)sg_left{
    return self.frame.origin.x;
}

- (void)setSg_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)sg_top {
    return self.frame.origin.y;
}

- (void)setSg_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)sg_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setSg_right:(CGFloat)sg_right {
    CGRect frame = self.frame;
    frame.origin.x = sg_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)sg_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setSg_bottom:(CGFloat)sg_bottom {
    CGRect frame = self.frame;
    frame.origin.y = sg_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)sg_centerX {
    return self.center.x;
}

- (void)setSg_centerX:(CGFloat)sg_centerX {
    self.center = CGPointMake(sg_centerX, self.center.y);
}

- (CGFloat)sg_centerY {
    return self.center.y;
}

- (void)setSg_centerY:(CGFloat)sg_centerY {
    self.center = CGPointMake(self.center.x, sg_centerY);
}

- (CGFloat)sg_width {
    return self.frame.size.width;
}

- (void)setSg_width:(CGFloat)sg_width {
    CGRect frame = self.frame;
    frame.size.width = sg_width;
    self.frame = frame;
}

- (CGFloat)sg_height {
    return self.frame.size.height;
}

- (void)setSg_height:(CGFloat)sg_height {
    CGRect frame = self.frame;
    frame.size.height = sg_height;
    self.frame = frame;
}

- (CGPoint)sg_origin {
    return self.frame.origin;
}

- (void)setSg_origin:(CGPoint)sg_origin {
    CGRect frame = self.frame;
    frame.origin = sg_origin;
    self.frame = frame;
}

- (CGSize)sg_size {
    return self.frame.size;
}

- (void)setSg_size:(CGSize)sg_size {
    CGRect frame = self.frame;
    frame.size = sg_size;
    self.frame = frame;
}

@end
