//
//  DDToDoData.m
//  DDooDo
//
//  Created by Sangsoo Park on 12. 3. 7..
//  Copyright (c) 2012년 nobird01@gmail.com. All rights reserved.
//

#import "DDToDoData.h"

@implementation DDToDoData
//@synthesize dataList = _dataList;


-(id)init {
    if ( self = [super init] ) {
        if (!_data) {
            _data = [[NSMutableArray alloc] init];
        }
    }
    return self;                      // self => c++에서의 this.
}

- (void) insertItem: (int) index : (NSDate*) date : (NSString*) title : (BOOL) isChecked 
{
    DDTodoItem* item = [[DDTodoItem alloc] init];
    item.date = date;
    item.title = title;
    item.isChecked = isChecked;    
    
    [_data insertObject:item atIndex:index];
}

- (void) removeItem: (int) index
{
    [_data removeObjectAtIndex:index];
}

- (DDTodoItem*) getItem: (int) index
{
    return [_data objectAtIndex: index];
}


- (int) count
{
    return _data.count;
}


-(NSMutableArray *)Items
{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    
    /////////
    return _data;
}

- (void)loadToDoData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *docFileName = [[NSString alloc] initWithFormat:@"%@/Todo.sav", docPath];
    
    NSLog(@"Load Todo Data from file");
    _data = [[NSMutableArray alloc] initWithContentsOfFile:docFileName];
}

- (void)saveTodoData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *docFileName = [[NSString alloc] initWithFormat:@"%@/Todo.sav", docPath];
    [_data writeToFile:docFileName atomically:YES];
}


@end



@implementation DDTodoItem

@synthesize date = _date;
@synthesize title = _title;
@synthesize isChecked = _isChecked;

@end
