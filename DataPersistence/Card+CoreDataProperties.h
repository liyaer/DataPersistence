//
//  Card+CoreDataProperties.h
//  DataPersistence
//
//  Created by 杜文亮 on 2017/10/12.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "Card+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

+ (NSFetchRequest<Card *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *no;
@property (nullable, nonatomic, retain) Person *person;

@end

NS_ASSUME_NONNULL_END
