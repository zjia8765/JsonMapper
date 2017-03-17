//
//  GlobalRaceModel.h
//  JsonMapper
//
//  Created by zhangjia on 2017/2/20.
//  Copyright © 2017年 zhangjia. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol RaceSourceModel;
@interface RaceSourceModel : JSONModel
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *imageId;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int filter;
@property (nonatomic, assign) BOOL star;
@end

@interface GlobalRaceModel : JSONModel
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageId;
@property (nonatomic, assign) long long timestamp;
@property (nonatomic, assign) int like;
@property (nonatomic, strong) NSString<Optional> *score;
@property (nonatomic, strong) NSNumber<Ignore> *tag;
@property (nonatomic, strong) RaceSourceModel *source;
@property (nonatomic, strong) NSArray<RaceSourceModel> *sourceArr;
@end
