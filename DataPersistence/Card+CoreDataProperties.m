//
//  Card+CoreDataProperties.m
//  DataPersistence
//
//  Created by 杜文亮 on 2017/10/12.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "Card+CoreDataProperties.h"

@implementation Card (CoreDataProperties)

+ (NSFetchRequest<Card *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Card"];
}

@dynamic no;
@dynamic person;

@end
