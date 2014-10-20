//
//  MenuButton.h
//  CircleMenu
//
//  Created by GaoYu on 14/10/20.
//  Copyright (c) 2014年 Warlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuButton : UIButton

//与y轴实时角度（逆时针方向），用于在拖动时候确定DragImageView的中心
@property(nonatomic) CGFloat yWithAngleNow;

//记录该位置初始的角度（与y轴）
@property(nonatomic) CGFloat yWithAngleOld;

//与x轴实时角度 用于DragImageView拖动停止后的旋转
@property(nonatomic) CGFloat xWithAngleNow;

//记录该位置初始角度（与x轴）
@property(nonatomic) CGFloat xWithAngleOld;

//DragImageView的中心
@property(nonatomic) CGPoint viewCenter;

@end
