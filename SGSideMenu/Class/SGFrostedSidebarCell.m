//
//  SGFrostedSidebarCell.m
//  SGSideMenu
//
//  Created by 殷绍刚 on 15/8/30.
//  Copyright (c) 2015年 ysghome. All rights reserved.
//

#import "SGFrostedSidebarCell.h"
#import "UIView+SGExtension.h"
#import "SGSideMenuConst.h"

@implementation SGFrostedSidebarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor grayColor]];
        _backImageView = [[UIImageView alloc] init];
        _backImageView.contentMode = UIViewContentModeScaleToFill;
        [_backImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_backImageView];
        
        _backLabel = [[UILabel alloc] init];
        [_backLabel setFont:[UIFont systemFontOfSize:16]];
        [_backLabel setTextColor:[UIColor whiteColor]];
        [_backLabel setNumberOfLines:1];
        [_backLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_backLabel];
        
        [self setBackgroundColor:SGGetColor(0, 0, 0, 0)];
    }
    return self;
}
/**
 *  重新设置视图中控件的位置
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    /**
     *  如果图片有改动 这里可以修改大小
     */
    UIImage *backImage = _backImageView.image;
    [_backImageView setFrame:CGRectMake(15, (self.sg_height - backImage.size.height)/2.f, backImage.size.width, backImage.size.height)];
    [_backLabel setFrame:CGRectMake(_backImageView.sg_right+5, 0, self.sg_width-_backImageView.sg_right-5, self.sg_height)];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
