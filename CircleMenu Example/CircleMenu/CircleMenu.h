//
//  CircleMenu.h
//  CircleMenu
//
//  Created by GaoYu on 14/10/20.
//  Copyright (c) 2014年 Warlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol circleMenuDelegate <NSObject>

//菜单上按钮点击响应事件
-(void)cilckAction:(NSInteger)tag;

@end

@interface CircleMenu : UIView<UIGestureRecognizerDelegate,circleMenuDelegate>{
    //圆的半径
    CGFloat radius;
    //圆心（在CircleView上的位置）
    CGPoint center;
    //平均角度
    CGFloat average_radina;
    //拖动的点
    CGPoint pointDrag;
    //拖动结束后间隔的个数
    NSInteger step;
}

@property(nonatomic,retain)NSMutableArray *arrButton;

@property(nonatomic,assign)id <circleMenuDelegate>delegate;

-(void)loadView;

@end
