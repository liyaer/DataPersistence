//
//  Person+CoreDataProperties.m
//  DataPersistence
//
//  Created by 杜文亮 on 2017/10/12.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic age;
@dynamic name;
@dynamic card;

@end
