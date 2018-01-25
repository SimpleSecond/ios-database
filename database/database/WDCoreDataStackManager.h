//
//  WDCoreDataStackManager.h
//  database
//
//  Created by WangDongya on 2018/1/25.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define wdyCoreDataManager [WDCoreDataStackManager sharedInstance]

@interface WDCoreDataStackManager : NSObject

// 管理对象上下文
@property (nonatomic, strong) NSManagedObjectContext *managerContext;
// 模型对象
@property (nonatomic, strong) NSManagedObjectModel *managerModel;
// 存储调度器
@property (nonatomic, strong) NSPersistentStoreCoordinator *managerDinator;


// 单例
+ (instancetype)sharedInstance;

// 保存数据方法
- (void)save;


@end
