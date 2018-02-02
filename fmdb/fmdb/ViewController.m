//
//  ViewController.m
//  fmdb
//
//  Created by WangDongya on 2018/1/28.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "ViewController.h"
#import <FMDB/FMDB.h>

@interface ViewController ()
{
    FMDatabase *_fmdb;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 创建数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [paths lastObject];
    // 应用文档目录
    NSLog(@"%@", documentStr);
    NSString *dbPath = [documentStr stringByAppendingPathComponent:@"Project.sqlite"];
    // 打开数据库，如果没有，则在该目录中创建该数据库
//    if () {
//        
//    }
    
    _fmdb = [FMDatabase databaseWithPath:dbPath];
}


#pragma mark - FMDB Create

- (void)fmdbCreate
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * dbPath = [documentPath stringByAppendingPathComponent:@"Project.sqlite"];
    // 数据库打开、创建
    _fmdb = [FMDatabase databaseWithPath:dbPath];
}

- (void)fmdbTableCreate
{
    NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR, age INTEGER, sex INTEGER, phone_number VARCHAR);", @"table_name"];
    // 创建数据表
    [self fmdbExecuteSql:sqlStr];
}


#pragma mark - FMDB Update

// FMDB多线程
- (void)fmdbQueue
{
    // 创建队列
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[@"" stringByAppendingPathComponent:@"Project.sqlite"]];
    
    __block BOOL tag = true;
    // 把任务放到队列里
    [queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        tag &= [db executeUpdate:@"INSERT INTO tb_user('age') VALUES(?)", [NSNumber numberWithInt:11]];
        tag &= [db executeUpdate:@"INSERT INTO tb_user('age') VALUES(?)", [NSNumber numberWithInt:22]];
        tag &= [db executeUpdate:@"INSERT INTO tb_user('age') VALUES(?)", [NSNumber numberWithInt:33]];
        
        // 如果有错误，回滚
        if (!tag) {
            *rollback = YES;
            return ;
        }
    }];
}


// FMDB查询数据
- (void)fmdbSelectData
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@", @"table"];
    // 根据条件查询，如果成功返回FMResultSet对象，错误返回nil。与执行更新相当，支持使用NSError参数。
    FMResultSet *resultSet = [_fmdb executeQuery:sqlQuery];
    
    // 遍历结果集合
    while ([resultSet next]) {
        NSString *name = [resultSet objectForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        int sex = [resultSet intForColumn:@"sex"];
        NSString *phone = [resultSet objectForColumn:@"phone_number"];
        
        NSLog(@"\n name : %@ \n age : %zd \n sex : %zd \n phone : %@ \n", name, age, sex, phone);
    }
    
    // FMDB封装过后的读取数据是要比原生的sqlite3方便了很多
}

// FMDB执行sql语句
- (void)fmdbExecuteSql:(NSString *)sqlStr
{
    if ([_fmdb open]) {
        // 只要sqlStr不是select命令的，都视为更新操作（executeUpdate方法）
        
        if ([_fmdb executeUpdate:sqlStr]) {
            NSLog(@"成功");
        } else {
            NSLog(@"失败");
        }
    } else {
        NSLog(@"FMDB数据库打开失败");
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
