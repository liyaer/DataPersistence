//
//  WriteToFileVC.m
//  DataPersistence
//
//  Created by 杜文亮 on 2017/9/26.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "WriteToFileVC.h"

@interface WriteToFileVC ()

@end

@implementation WriteToFileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 以字典为例
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"母鸡" forKey:@"name"];
    [dict setObject:@"15013141314" forKey:@"phone"];
    [dict setObject:@"27" forKey:@"age"];
    // 将字典持久化到Documents/stu.plist文件中(存成txt也行，但是plist文件可以用xcode打开，容易观察)
    NSString *path = [NSString stringWithFormat:@"%@/dic.plist",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject];
    [dict writeToFile:path atomically:YES];
    
    
    //读取
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"%@",dic);
}


@end
