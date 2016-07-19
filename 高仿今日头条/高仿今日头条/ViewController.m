//
//  ViewController.m
//  高仿今日头条
//
//  Created by 高崇 on 16/7/19.
//  Copyright © 2016年 LieLvWang. All rights reserved.
//

#import "ViewController.h"
#import "GCNewsDesController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)next_click
{
    [self.navigationController pushViewController:[GCNewsDesController new] animated:YES];
}



@end
