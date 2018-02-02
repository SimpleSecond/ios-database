//
//  ViewController.m
//  sqlite3
//
//  Created by WangDongya on 2018/1/29.
//  Copyright © 2018年 wdy-test. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

@interface ViewController ()
{
    sqlite3 *db;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 创建数据库
- (void)createDatabase
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *databasePath = [documentPath stringByAppendingPathComponent:@"Project.sqlite"];
    
    // 打开数据库，如果没有的话，就会在该目录创建数据库。
    if (sqlite3_open([databasePath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
    }
}

// 创建数据表
- (void)createTable
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR, age INTEGER, sex INTEGER, phone_number VARCHAR);", @"table"];
    
    // 执行语句
    [self executeSql:sql];
}

// 插入数据
- (void)insertData
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO '%@'('name', 'age', 'sex', 'phone_number') VALUES('%@', '%@', '%@', '%@')", @"table", @"张三", @"23", @"1", @"18875092312"];
    [self executeSql:sql];
    
    sql = [NSString stringWithFormat:@"INSERT INTO '%@'('name', 'age', 'sex', 'phone_number') VALUES('%@', '%@', '%@', '%@')", @"table", @"李四", @"24", @"0", @"18875092312"];
    [self executeSql:sql];
    
    sql = [NSString stringWithFormat:@"INSERT INTO '%@'('name', 'age', 'sex', 'phone_number') VALUES('%@', '%@', '%@', '%@')", @"table", @"龙九", @"35", @"1", @"18875092312"];
    [self executeSql:sql];
}

// 查询数据
- (void)queryDataWithTable:(NSString *)table
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    sqlite3_open([[documentPath stringByAppendingPathComponent:@"table"] UTF8String], &db);
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@", table];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
        char *name = (char*)sqlite3_column_text(statement, 1);
        NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
        
        int age = sqlite3_column_int(statement, 2);
        int sex = sqlite3_column_int(statement, 3);
        
        int columnCount = sqlite3_column_count(statement);
        if (columnCount == 5) {
            char *phoneNum = (char *)sqlite3_column_text(statement, 4);
            NSString *phoneStr = [[NSString alloc] initWithUTF8String:phoneNum];
            NSLog(@"");
        } else {
            NSLog(@"");
        }
    } else {
        NSLog(@"查询数据失败");
    }
    sqlite3_close(db);
}



// 执行SQL语句
- (void)executeSql:(NSString *)sql
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    char *err;
    sqlite3_open([[documentPath stringByAppendingPathComponent:@"table"] UTF8String], &db);
    sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err);
    sqlite3_close(db);
}


@end
