//
//  DDToDoData.m
//  DDooDo
//
//  Created by Sangsoo Park on 12. 3. 7..
//  Copyright (c) 2012년 nobird01@gmail.com. All rights reserved.
//

#import <EventKit/EventKit.h>

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
    
    if (date) {
        event.startDate = date;
        event.endDate = [date dateByAddingTimeInterval:60 * 60];
    }
    else {
        event.allDay = TRUE;
    }
    
    BOOL saved = [store saveEvent:event span:EKSpanThisEvent error:NULL];
    
    NSString *result;
    if (saved == TRUE)
        result = [event eventIdentifier];
    else
        result =  nil;

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

    NSLog(@"_data Count 1 - %d", _data.count);
    
    NSMutableArray *tmpData = [[NSMutableArray alloc] initWithContentsOfFile:docFileName];
    [_data removeAllObjects];
    
    NSLog(@"tmpData Count 2 - %d", tmpData.count);
    
    NSLog(@"_data Count 2 - %d", _data.count);
    
    [_data addObjectsFromArray:tmpData];
    
    NSLog(@"_data Count 3 - %d", _data.count);
    
    [tmpData removeAllObjects];
    tmpData = nil;
}

- (void)saveDataToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *docFileName = [[NSString alloc] initWithFormat:@"%@/Todo.sav", docPath];
    [_data writeToFile:docFileName atomically:YES];
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

@end
