//
//  ViewController.m
//  database
//
//  Created by WangDongya on 2018/1/23.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "ViewController.h"
#import "Person+CoreDataProperties.h"
#import "WDCoreDataStackManager.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    NSLog(@"Class Name : %@", NSStringFromClass([Person class]));
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testScanPerson
{
    // 查询数据
    // 1. 创建一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    // 2. 创建谓词（查询条件）
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"张三"];
    // 3. 给查询请求设置谓词
    request.predicate = predicate;
    // 4. 查询数据
    NSArray<Person*> *arr = [wdyCoreDataManager.managerContext executeFetchRequest:request error:nil];
    NSLog(@"result count : %zd", arr.count);
}


- (void)testUpdatePerson
{
    // 修改数据
    // 1. 创建一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    // 2. 创建查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"张三"];
    // 3. 给查询请求设置查询条件
    request.predicate = predicate;
    // 4. 查询数据
    NSArray<Person *> *arr = [wdyCoreDataManager.managerContext executeFetchRequest:request error:nil];
    // 5. 改变数据
    arr.firstObject.name = @"李四";
    arr.firstObject.age = 50;
    // 6. 同步到数据库
    [wdyCoreDataManager save];
}


- (void)testDeletePerson
{
    // 删除数据
    // 1. 创建一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    // 2. 创建查询谓词（查询条件）
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"张三"];
    // 3. 给查询请求设置谓词
    request.predicate = predicate;
    // 4. 查询数据
    NSArray<Person *> *arr = [wdyCoreDataManager.managerContext executeFetchRequest:request error:nil];
    // 5. 删除数据
    [wdyCoreDataManager.managerContext deleteObject:arr.firstObject];
    // 6. 同步到数据库
    [wdyCoreDataManager save];
}


- (void)testAddPerson
{
    // 保存数据
    Person *p = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:wdyCoreDataManager.managerContext];
    p.age = 13;
    p.name = @"张三";
    [wdyCoreDataManager save];
}


- (void)testPerson
{
    // 1. 创建模型对象
    // 获取模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Project" withExtension:@"momd"];
    // 根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    // 2. 创建持久化助理
    // 利用模型对象创建助理对象
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 数据库的名称和路径
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *databasePath = [docStr stringByAppendingPathComponent:@"mySqlite.sqlite"];
    NSLog(@"path = %@", databasePath);
    NSURL *sqlURL = [NSURL fileURLWithPath:databasePath];
    
    // 设置数据库相关信息
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlURL options:nil error:nil];
    
    
    // 3. 创建上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    // 关联持久化助理
    [context setPersistentStoreCoordinator:store];
    
    //_context = context;
}

@end
