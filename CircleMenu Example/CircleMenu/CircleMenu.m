//
//  CircleMenu.m
//  CircleMenu
//
//  Created by GaoYu on 14/10/20.
//  Copyright (c) 2014年 Warlock. All rights reserved.
//

#import "CircleMenu.h"
#import "MenuButton.h"

@implementation CircleMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
    }
    return self;
}

- (void)loadView{
    if (_arrButton.count > 0) {
        [self createButton];
        [self addGesture];
    }else{
        return;
    }
}

-(void)createButton{
    CGFloat fRadina;//与y轴的夹角
    average_radina = 2*M_PI/_arrButton.count;
    MenuButton *menuButton = [_arrButton objectAtIndex:0];
    CGFloat width = menuButton.frame.size.width;
    CGFloat heigh = menuButton.frame.size.height;
    //计算半径
    radius = MIN(self.frame.size.width-width, self.frame.size.height-heigh)/2.0;
    for (int i=0; i<_arrButton.count; i++) {
        fRadina = [self getRadinaByRadian:i*average_radina];
        CGPoint point = [self getPointByRadian:fRadina centreOfCircle:center radiusOfCircle:radius];
        MenuButton *menuButton = [_arrButton objectAtIndex:i];
        menuButton.center = point;
        
        menuButton.yWithAngleOld = fRadina;
        
        menuButton.viewCenter = point;

        menuButton.xWithAngleNow = [self getAnimationRadianByRadian:fRadina];
        menuButton.xWithAngleOld = [self getAnimationRadianByRadian:fRadina];
        menuButton.yWithAngleNow = fRadina;
        
        menuButton.tag = i;
        
        [menuButton addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
        
    }

}

//计算线与y轴的夹角,确保在0～2*M_PI之间
- (CGFloat)getRadinaByRadian:(CGFloat)radian
{
    if(radian > 2 * M_PI)//floorf表示不大于该数的最大整数
        return (radian - floorf(radian / (2.0f * M_PI)) * 2.0f * M_PI);
    
    if(radian < 0.0f)//ceilf表示不小于于该数的最小整数
        return (2.0f * M_PI + radian - ceilf(radian / (2.0f * M_PI)) * 2.0f * M_PI);
    
    return radian;
}

//根据夹角（与y轴），中心点，半径就出点坐标
- (CGPoint)getPointByRadian:(CGFloat)radian centreOfCircle:(CGPoint)circle_point radiusOfCircle:(CGFloat)circle_radius
{
    CGFloat c_x = sinf(radian) * circle_radius + circle_point.x;
    CGFloat c_y = cosf(radian) * circle_radius + circle_point.y;
    
    return CGPointMake(c_x, c_y);
}

//根据和y轴的夹角换算成与x轴的夹角用于拖动后旋转
- (CGFloat)getAnimationRadianByRadian:(CGFloat)radian
{
    
    CGFloat an_r = 2.0f * M_PI -  radian + M_PI_2;
    
    if(an_r < 0.0f)
        an_r =  - an_r;
    
    return an_r;
}

/*
 添加手势
 */
- (void)addGesture{
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSinglePan:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

//手势操作
- (void)handleSinglePan:(id)sender{
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)sender;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            pointDrag = [panGesture locationInView:self];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint pointMove = [panGesture locationInView:self];
            [self dragPoint:pointDrag movePoint:pointMove centerPoint:center];
            pointDrag = pointMove;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint pointMove = [panGesture locationInView:self];
            [self dragPoint:pointDrag movePoint:pointMove centerPoint:center];
            [self reviseCirclePoint];
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
            CGPoint pointMove = [panGesture locationInView:self];
            [self dragPoint:pointDrag movePoint:pointMove centerPoint:center];
            [self reviseCirclePoint];
        }
            break;
            
        default:
            break;
    }
}

//随着拖动改变子view位置，子view与y轴的夹角，子view与x轴的夹角
- (void)dragPoint:(CGPoint)dragPoint movePoint:(CGPoint)movePoint centerPoint:(CGPoint)centerPoint{
    CGFloat drag_radian   = [self schAtan2f:dragPoint.x - centerPoint.x theB:dragPoint.y - centerPoint.y];
    
    CGFloat move_radian   = [self schAtan2f:movePoint.x - centerPoint.x theB:movePoint.y - centerPoint.y];
    
    CGFloat change_radian = (move_radian - drag_radian);
    for (int i=0; i<_arrButton.count; i++) {
        MenuButton *menuButton = [_arrButton objectAtIndex:i];
        menuButton.center = [self getPointByRadian:(menuButton.yWithAngleNow+change_radian) centreOfCircle:center radiusOfCircle:radius];
        menuButton.yWithAngleNow = [self getRadinaByRadian:menuButton.yWithAngleNow + change_radian];;
        menuButton.xWithAngleNow = [self getAnimationRadianByRadian:menuButton.yWithAngleNow];
        
    }
}

//计算schAtan值
- (CGFloat)schAtan2f:(CGFloat)a theB:(CGFloat)b
{
    CGFloat rd = atan2f(a,b);
    
    if(rd < 0.0f)
        rd = M_PI * 2 + rd;
    
    return rd;
}

//旋转结束后滑动到指定位置
- (void)reviseCirclePoint{
    
    
    BOOL isClockwise;
    
    
    MenuButton *buttonFirst = [_arrButton objectAtIndex:0];
    CGFloat temp_value = [self getRadinaByRadian:buttonFirst.yWithAngleNow]/average_radina;
    NSInteger iCurrent = (NSInteger)(floorf(temp_value));
    temp_value = temp_value - floorf(temp_value);
    
    step = iCurrent;
    if (temp_value > 0.5f) {//超过半个弧度
        isClockwise = NO;
        step ++;
    }else{
        isClockwise = YES;
    }
    
    for (int i=0; i<_arrButton.count; i++) {
        NSInteger iDest = i+step;
        if (iDest >= _arrButton.count) {
            iDest = iDest%_arrButton.count;
        }
        [self animateWithDuration:0.3f * (temp_value/average_radina)  animateDelay:0.0f changeIndex:i toIndex:iDest circleArray:_arrButton clockwise:isClockwise];
    }
}

//平衡动画
- (void)animateWithDuration:(CGFloat)time animateDelay:(CGFloat)delay changeIndex:(NSInteger)change_index toIndex:(NSInteger)to_index circleArray:(NSMutableArray *)array clockwise:(BOOL)is_clockwise{
    
    MenuButton *change_cell = [array objectAtIndex:change_index];
    MenuButton *to_cell     = [array objectAtIndex:to_index];
    
    /*圆*/
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:[NSString stringWithFormat:@"position"]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,change_cell.layer.position.x,change_cell.layer.position.y);
    
    int clockwise = is_clockwise?0:1;
    
    CGPathAddArc(path,nil,
                 center.x, center.y, /*圆心*/
                 radius,                          /*半径*/
                 change_cell.xWithAngleNow, to_cell.xWithAngleOld, /*弧度改变*/
                 clockwise
                 );
    animation.path = path;
    CGPathRelease(path);
    animation.fillMode            = kCAFillModeForwards;
    animation.repeatCount         = 1;
    animation.removedOnCompletion = NO;
    animation.calculationMode     = @"paced";
    
    /*动画组合*/
    CAAnimationGroup *anim_group  = [CAAnimationGroup animation];
    anim_group.animations          = [NSArray arrayWithObjects:animation, nil];
    anim_group.duration            = time + delay;
    anim_group.delegate            = self;
    anim_group.fillMode            = kCAFillModeForwards;
    anim_group.removedOnCompletion = NO;
    
    [change_cell.layer addAnimation:anim_group forKey:[NSString stringWithFormat:@"anim_group_%d",change_index]];
    
    /*改变属性*/
    change_cell.xWithAngleNow = to_cell.xWithAngleOld;
    change_cell.yWithAngleNow = to_cell.yWithAngleOld;
}

#pragma mark -
#pragma mark - animation delegate

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{    
    for (int i = 0; i < _arrButton.count; ++i)
    {
        NSInteger iDest = i+step;
        if (iDest >= _arrButton.count) {
            iDest = iDest%_arrButton.count;
        }
        MenuButton *change_cell = [_arrButton objectAtIndex:i];
        
        MenuButton *to_cell     = [_arrButton objectAtIndex:iDest];
        
        [change_cell.layer removeAllAnimations];
        
        change_cell.center    = to_cell.viewCenter;
    }
}

-(void)selectedAction:(UIButton *)btn{
    [_delegate cilckAction:btn.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
