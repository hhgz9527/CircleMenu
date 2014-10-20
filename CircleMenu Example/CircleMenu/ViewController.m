//
//  ViewController.m
//  CircleMenu
//
//  Created by GaoYu on 14/10/20.
//  Copyright (c) 2014年 Warlock. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i ++) {
        MenuButton *menuButton = [MenuButton buttonWithType:UIButtonTypeRoundedRect];
        [menuButton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        menuButton.frame = CGRectMake(0, 0, 40, 40);
        menuButton.tag = i;
        [arr addObject:menuButton];
        
    }
    
    
    circleMenu = [[CircleMenu alloc] initWithFrame:CGRectMake(0, 200, 300, 300)];
    circleMenu.arrButton = arr;
    circleMenu.delegate = self;
    [self.view addSubview:circleMenu];
    [circleMenu loadView];
    
}

#pragma mark - circleMenu Delegate
-(void)cilckAction:(NSInteger)tag{
    switch (tag) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
            NSLog(@"1");
            break;
        case 2:
            NSLog(@"2");
            break;
        case 3:
            NSLog(@"3");
            break;
        case 4:
            break;
        case 5:
            NSLog(@"5");
            break;
        case 6:
            NSLog(@"6");
            break;
        case 7:
            NSLog(@"7");
            break;
        case 8:
            NSLog(@"8");
            break;
        case 9:
            NSLog(@"9");
            break;
        default:
            break;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
