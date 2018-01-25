//
//  WDCoreDataStackManager.m
//  database
//
//  Created by WangDongya on 2018/1/25.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "WDCoreDataStackManager.h"

@implementation WDCoreDataStackManager


+ (instancetype)sharedInstance
{
    static WDCoreDataStackManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WDCoreDataStackManager alloc] init];
    });
    return instance;
}

- (void)save
{
    // 保存数据
    [self.managerContext save:nil];
}


#pragma mark - 私有方法

- (NSURL *)getDocumentURLPath
{
    // 获取文件位置
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return url;
}

#pragma mark - 懒加载
- (NSManagedObjectModel *)managerModel
{
    if (!_managerModel) {
        _managerModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managerModel;
}

- (NSPersistentStoreCoordinator *)managerDinator
{
    if (!_managerDinator) {
        _managerDinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managerModel];
        
        // 添加存储器
        // type : 一般使用数据库存储方式NSSQLiteStoreType
        // configuration : 配置信息，一般无需配置
        // URL : 要保存的文件路径
        // options : 参数信息，一般无需设置
        
        // 拼接URL路径
        NSURL *url = [[self getDocumentURLPath] URLByAppendingPathComponent:@"sqlite.db" isDirectory:YES];
        
        NSLog(@"%@", url.path);
        
        [_managerDinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    }
    return _managerDinator;
}

- (NSManagedObjectContext *)managerContext
{
    if (!_managerContext) {
        _managerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        // 设置存储调度器
        [_managerContext setPersistentStoreCoordinator:self.managerDinator];
    }
    return _managerContext;
}


@end
