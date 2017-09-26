//
//  NSKeyedArchiverVC.m
//  DataPersistence
//
//  Created by 杜文亮 on 2017/9/25.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "NSKeyedArchiverVC.h"

//这里偷懒直接将模型类写在这里了，可以独立出去成一个模型类文件(写在这里这个person类只能在这个类NSKeyedArchiverVC内部调用)
@interface person : NSObject<NSCoding>

@property (nonatomic,copy) NSString *p_name;
@property (nonatomic,assign) int p_age;
@property (nonatomic,assign) float p_height;

@end

@implementation person

-(instancetype)initWithName:(NSString *)name age:(int)age height:(float)height
{
    if (self = [super init])
    {
        _p_name = name;
        _p_age = age;
        _p_height = height;
    }
    return self;
}
/*
 *   NSKeyedArchiver-归档对象的注意
        - 如果父类也遵守了NSCoding协议，请注意：应该在encodeWithCoder:方法中加上一句[super encodeWithCode:encode];确保继承的实例变量也能被编码，即也能被归档
        - 应该在initWithCoder:方法中加上一句self = [super initWithCoder:decoder];确保继承的实例变量也能被解码，即也能被恢复
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.p_name forKey:@"name"];
    [encoder encodeInt:self.p_age forKey:@"age"];
    [encoder encodeFloat:self.p_height forKey:@"height"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
         self.p_name = [decoder decodeObjectForKey:@"name"];
         self.p_age = [decoder decodeIntForKey:@"age"];
         self.p_height = [decoder decodeFloatForKey:@"height"];
    }
    return self;
}

/*
 *  此部分是拓展内容（联合上面Array和dictionary的两个分类一起，都是关于description方法的扩展内容，实现自定义内容的打印）
 
 *  在使用NSObject类替换%@占位符时，会调用description相关方法，所以只要实现此方法，就可以起到修改打印内容的作用。对于系统的类，才用增加分类的方式实现，而自定义的类，就是重写description方法
 */
-(NSString *)description
{
    return [NSString stringWithFormat:@"内存地址：%p  姓名：%@  年龄：%d  身高：%.2f",self,_p_name,_p_age,_p_height];
}

@end




@interface NSKeyedArchiverVC ()

@end

@implementation NSKeyedArchiverVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
 *   将单个对象进行归档解档
 */

//1，已dic为例，其他类似
- (IBAction)archiveOne:(id)sender
{
    //归档
    NSDictionary *dic = @{@"我":@"1",@"12.0":@"ssd"};
    NSString *path = [NSString stringWithFormat:@"%@/dic.archive",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    [NSKeyedArchiver archiveRootObject:dic toFile:path];
    
    //解档
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"从归档的文件中解档：%@",dict);
}

//2，自定义模型对象
- (IBAction)archiveTwo:(id)sender
{
    //归档
    NSString *path = [NSString stringWithFormat:@"%@/person.archive",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    [NSKeyedArchiver archiveRootObject:[[person alloc] initWithName:@"张三" age:14 height:34.098] toFile:path];
    
    //解档
    person *p = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"从归档的文件中解档：%@",p);
}

/*
 *   将多个对象进行归档解档
        1. 使用archiveRootObject:toFile:方法可以将一个对象直接写入到一个文件中，但有时候可能想将多个对象写入到同一个文件中，那么就要使用NSData来进行归档对象。NSData可以为一些数据提供临时存储空间，以便随后写入文件，或者存放从磁盘读取的文件内容。可以使用[NSMutableData data]创建可变数据空间。（没有2简单）
        2.将多个对象放入到一个数组中，对数组进行归档，在数组对象执行archiveRootObject:toFile时，数组中每个对象会自动调用encodeWithCoder:方法进行归档；相反数组文件进行解档时，在数组对象执行unarchiveObjectWithFile:时，数组中每个对象会自动调用initWithCoder:方法进行解档。（推荐使用）
 */

//一次归档解档多个基本数据类型对象
- (IBAction)archiveOne_S:(id)sender
{
    //方式1实现
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:@{@"qiqi":@"1",@"haha":@"2"} forKey:@"dic1"];
    [archiver encodeObject:@{@"benben":@"10",@"gugu":@"20"} forKey:@"dic2"];
    [archiver finishEncoding];
    NSString *path = [NSString stringWithFormat:@"%@/moreDics.archive",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    [data writeToFile:path atomically:YES];
    
    NSData *datas = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:datas];
    NSDictionary *dic1 = [unarchiver decodeObjectForKey:@"dic1"];
    NSDictionary *dic2 = [unarchiver decodeObjectForKey:@"dic2"];
    [unarchiver finishDecoding];
    NSLog(@"%@\n%@",dic1,dic2);
    
    //方式2实现
    NSArray *arr = @[dic1,dic2];
    [NSKeyedArchiver archiveRootObject:arr toFile:path];
    
    NSArray *arrs = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"%@",arrs);
}

//一次归档解档多个自定义数据类型对象
- (IBAction)archiveTwo_S:(id)sender
{
    //方式1实现
    //通过可变data归档多个对象
    // 新建一块可变数据区
    NSMutableData *data = [NSMutableData data];
    // 将数据区连接到一个NSKeyedArchiver对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    // 开始存档对象，存档的数据都会存储到NSMutableData中
    [archiver encodeObject:[[person alloc] initWithName:@"李四" age:45 height:12.0] forKey:@"person1"];
    [archiver encodeObject:[[person alloc] initWithName:@"王五" age:23 height:23.0] forKey:@"person2"];
    // 存档完毕(一定要调用这个方法，调用了这个方法，archiver才会将encode的数据存储到NSMutableData中)
    [archiver finishEncoding];
    // 将存档的数据写入文件
    NSString *path = [NSString stringWithFormat:@"%@/morePerson.archive",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    [data writeToFile:path atomically:YES];
    
    //解档多个对象
    // 从文件中读取数据
    NSData *datas = [NSData dataWithContentsOfFile:path];
    // 根据数据，解析成一个NSKeyedUnarchiver对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:datas];
    person *person1 = [unarchiver decodeObjectForKey:@"person1"];
    person *person2 = [unarchiver decodeObjectForKey:@"person2"];
    // 恢复完毕(这个方法调用之后，unarchiver不能再decode对象，而且会通知unarchiver的代理调用unarchiverWillFinish:和unarchiverDidFinish:方法)
    [unarchiver finishDecoding];
    NSLog(@"从归档的文件中解档：%@",person1);
    NSLog(@"从归档的文件中解档：%@",person2);
    
    //方式2实现
    NSArray *arr = @[person1,person2];
    [NSKeyedArchiver archiveRootObject:arr toFile:path];
    
    NSArray *arrs = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    for (person *p in arrs)
    {
        NSLog(@"从归档的文件中解档：%@",p);
    }
}




#pragma mark - 扩展，通过归档解档实现深拷贝

- (IBAction)copyCompletely:(id)sender
{
    NSDictionary *dic = @{@"背景":@"6",@"天安门":@"000"};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];//放入data中暂存（归档）
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];//从data中解析（解档）
    NSLog(@"原始：%p\n现在：%p",dic,dict);//注意查看内存地址
}


@end
