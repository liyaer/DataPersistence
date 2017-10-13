//
//  CoreDataVC.m
//  DataPersistence
//
//  Created by 杜文亮 on 2017/10/12.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "CoreDataVC.h"
#import <CoreData/CoreData.h>
#import "Person+CoreDataClass.h"
#import "Card+CoreDataClass.h"

@interface CoreDataVC ()

@end

@implementation CoreDataVC
{
    NSManagedObjectContext *_context;
    NSMutableArray *_datas;//仅仅为了方便演示而写的测试属性
}

/*
 *   为了保证代码运行正常，请在每次进行了增、删、改操作之后立马进行一次查询，以保证我们测试属性_data保持最新
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _datas = [NSMutableArray arrayWithCapacity:10];
    //使用前的准备工作
    [self prepareCoreData];
}

-(void)prepareCoreData
{
    //1,从应用程序包中加载模型文件(Model.xcdatamodeld)
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    
    //2,传入模型，初始化NSPersistentStoreCoordinator,创建数据库
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //构建SQLite文件路径
    NSString *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.data"]];
    //添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil)// 直接抛异常
    {
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    
    
    //3，初始化上下文，设置persistentStoreCoordinator属性
    _context = [[NSManagedObjectContext alloc] init];
    _context.persistentStoreCoordinator = psc;
}

//通过NSManagedObjectContext将数据写入数据库(增)
- (IBAction)insertData:(id)sender
{
    //1.1,传入上下文，创建一个Person实体对象
    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:_context];
    [person setValue:@"hosea" forKey:@"name"];
    [person setValue:[NSNumber numberWithInt:22] forKey:@"age"];
    /*
     *   如果生成了实体对应的模型文件，那么可以像模型一样来调用实体属性。（注意：需要在Model.xcdatamodeld中将实体的Codegen属性设置为Manual\None,否则会出现编译错误）当然继续通过上面的方式使用实体也是可以的，不过一般我们都会采用下面这种写法，调用方便
        
         Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:_context];
         person.name = @"hoGGGGGG";
         person.age = 22;

     */
    //1.2,传入上下文，创建一个Card实体对象
    NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:_context];
    [card setValue:@"4414241933432" forKey:@"no"];
    //1.3,设置Person和Card之间的关联关系
    [person setValue:card forKey:@"card"];
    
    //2,利用上下文对象，将数据同步到持久化存储库
    NSError *error = nil;
    BOOL success = [_context save:&error];
    if (!success)
    {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }
    //如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库
}

//查询数据（查） 可以根据过滤条件实现单条查询和查询所有,这里我们每次添加数据都一样所以不论条件怎么设置，查询结果都等同于查询所有
- (IBAction)selectData:(id)sender
{
    //1.1,初始化一个查询请求(需要指定查询实体)
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    //下面三局代码和上面一句代码等效
    //    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    //    request.entity = desc;
    //1.2,设置排序（按照age降序）
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    //1.3,设置条件过滤(name like '%ho%')
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*ho*"];
    request.predicate = predicate;
    
    //2,执行请求
    NSError *error = nil;
    NSArray *objs = [_context executeFetchRequest:request error:&error];
    if (error)
    {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    //遍历数据
    [_datas removeAllObjects];
    for (NSManagedObject *obj in objs)
    {
        NSLog(@"name=%@", [obj valueForKey:@"name"]);
        [_datas addObject:obj];
    }
}

//删除数据（删）
- (IBAction)removeData:(id)sender
{
    //,1传入需要删除的实体对象
    [_context deleteObject:_datas[0]];
    [_datas removeObjectAtIndex:0];
    
    //2,将结果同步到数据库
    NSError *error = nil;
    [_context save:&error];
    if (error)
    {
        [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]];
    }
}

//更新数据（改）
- (IBAction)updateData:(id)sender
{
    //1
    NSManagedObject *person = _datas[0];
    [person setValue:@"hoduwenliang" forKey:@"name"];
    
    //2,将结果同步到数据库
    NSError *error = nil;
    [_context save:&error];
    if (error)
    {
        [NSException raise:@"更新错误" format:@"%@", [error localizedDescription]];
    }
}


@end
