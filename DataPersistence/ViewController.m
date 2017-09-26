//
//  ViewController.m
//  DataPersistence
//
//  Created by 杜文亮 on 2017/9/25.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"沙盒Doc路径：%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);
}



@end
