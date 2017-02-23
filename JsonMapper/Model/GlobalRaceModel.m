//
//  GlobalRaceModel.m
//  JsonMapper
//
//  Created by zhangjia on 2017/2/20.
//  Copyright © 2017年 zhangjia. All rights reserved.
//

#import "GlobalRaceModel.h"

@implementation RaceSourceModel

@end

@implementation GlobalRaceModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"rid":@"id"}];
}
@end
