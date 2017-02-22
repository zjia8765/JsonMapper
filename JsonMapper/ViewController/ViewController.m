//
//  ViewController.m
//  JsonMapper
//
//  Created by zhangjia on 2017/2/20.
//  Copyright © 2017年 zhangjia. All rights reserved.
//

#import "ViewController.h"
#import "GlobalRaceModel.h"
#import <objc/runtime.h>
#import "GlobalRaceModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPropertyList:(id)sender {
    
    NSArray *classArray = @[@"GlobalRaceModel",@"RaceSourceModel"];
    for (NSString *className in classArray) {
        NSLog(@">>>>>>>>>>begin %@ property >>>>>>>>>\n",className);
        id class = objc_getClass([className UTF8String]);
        
        unsigned int outCount, i;
        
        objc_property_t *properties = class_copyPropertyList(class, &outCount);
        
        for (i = 0; i < outCount; i++) {
            
            objc_property_t property = properties[i];
            
            fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));
            
        }
        
        NSLog(@"\n>>>>>>>>>>end %@ property >>>>>>>>>",className);
    }
    
    
    
}
- (IBAction)analysisModel:(id)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *result = [jsonDic objectForKey:@"result"];
    GlobalRaceModel *raceModel = [[GlobalRaceModel alloc] initWithDictionary:result error:nil];
    NSLog(@"%@",[raceModel toJSONString]);
}

@end
