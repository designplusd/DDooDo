벼//
//  DDToDoData.m
//  DDooDo
//
//  Created by Sangsoo Park on 12. 3. 7..
//  Copyright (c) 2012년 nobird01@gmail.com. All rights reserved.
//

#import <EventKit/EventKit.h>

#import "DDToDoData.h"

@implementation DDToDoData


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

- (void) insertItem: (int) index : (DDTodoItem*) item
{
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


- (NSString *) SaveEvent:(NSString *)title :(NSDate *)date
{
    EKEventStore *store = [[EKEventStore alloc] init];
    EKCalendar *calendar = store.defaultCalendarForNewEvents;
    EKEvent *event = [EKEvent eventWithEventStore:store];
    
    event.title = title;
    event.calendar = calendar;
    event.startDate = date;
    event.endDate = [date dateByAddingTimeInterval:60 * 60];
    event.allDay = TRUE;
    
    BOOL saved = [store saveEvent:event span:EKSpanThisEvent error:NULL];
    
    NSString *result;
    if (saved == TRUE)
        result = [event eventIdentifier];
    else
        result = nil;

    return result;
}

-(void) RemoveEvent:(NSString *)identifier
{
    EKEventStore *store = [[EKEventStore alloc] init];
    EKEvent *event = [store eventWithIdentifier:identifier];
    
    [store removeEvent:event span:EKSpanThisEvent error:NULL];
}

- (void)loadDataFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *docFileName = [[NSString alloc] initWithFormat:@"%@/Todo.sav", docPath];
    
    NSData *dataArea = [NSData dataWithContentsOfFile:docFileName];
    if (!dataArea)
        return;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataArea];
  
    int count = [unarchiver decodeIntForKey:@"ToDoDataCount"];

    [_data removeAllObjects];
    
    for (int i = 0; i < count; ++i)
    {
        NSString *keyStr = [[NSString alloc] initWithFormat:@"ToDoData%d", i];
        DDTodoItem *curItem = [unarchiver decodeObjectForKey:keyStr];
        if (curItem)
            [_data addObject:curItem];
    }
    
    [unarchiver finishDecoding];
}

- (void)saveDataToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *docFileName = [[NSString alloc] initWithFormat:@"%@/Todo.sav", docPath];
    
    NSMutableData *dataArea = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataArea];

    [archiver encodeInt:_data.count forKey:@"ToDoDataCount"];
    
    for (int i = 0; i < _data.count; ++i)
    {
        NSString *keyStr = [[NSString alloc] initWithFormat:@"ToDoData%d", i];
        DDTodoItem *curItem = [_data objectAtIndex:i];
        
        [archiver encodeObject:curItem forKey:keyStr];
    }
    
    [archiver finishEncoding];

    [dataArea writeToFile:docFileName atomically:YES];
}

- (void)loadData
{
    [self loadDataFromFile];
}

- (void)saveData
{
    [self saveDataToFile];
}

@end


@implementation DDTodoItem

@synthesize date = _date;
@synthesize title = _title;
@synthesize isChecked = _isChecked;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_date forKey:@"TodoItemDate"];
    [aCoder encodeObject:_title forKey:@"TodoItemTitle"];
    [aCoder encodeBool:_isChecked forKey:@"TodoItemIsChecked"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    _date = [aDecoder decodeObjectForKey:@"TodoItemDate"];
    _title = [aDecoder decodeObjectForKey:@"TodoItemTitle"];
    _isChecked = [aDecoder decodeBoolForKey:@"TodoItemIsChecked"];

    return self;
}

@end
