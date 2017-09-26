//
//  NSKeyedArchiverVC.h
//  DataPersistence
//
//  Created by 杜文亮 on 2017/9/25.
//  Copyright © 2017年 杜文亮. All rights reserved.
//


/*
 *  归档解档的适用情况：（Demo中分别对这两种情况进行了示例，并用1，2对应这里的说明）
 
        1.某些系统级别的简单数据类型。如果对象是NSString、NSDictionary、NSArray、NSData、NSNumber等类型，可以直接用NSKeyedArchiver进行归档和恢复。(这些基本数据类型都遵守并实现了NSCoding协议)
 
        2.自定义的对象。不是所有的对象都可以“直接”用这种方法进行归档，只有遵守了NSCoding协议的对象才可以。我们自定义的对象需要手动遵守NSCoding协议，并实现协议方法。
 
 *  NSCoding协议有2个方法：
 
        encodeWithCoder:
        每次归档对象时，都会调用这个方法。一般在这个方法里面指定如何归档对象中的每个实例变量，可以使用encodeObject:forKey:方法归档实例变量
 
        initWithCoder:
        每次从文件中恢复(解码)对象时，都会调用这个方法。一般在这个方法里面指定如何解码文件中的数据为对象的实例变量，可以使用decodeObject:forKey方法解码实例变量
 */

#import <UIKit/UIKit.h>

@interface NSKeyedArchiverVC : UIViewController

@end
