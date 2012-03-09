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

-(id)init {
    if ( self = [super init] ) {
        if (!data) {
            data = [[NSMutableArray alloc] init];
        }
    }
    return self;                      // self => c++에서의 this.
}


-(NSMutableArray *)Items
{
    if (!data) {
        data = [[NSMutableArray alloc] init];
    }
    
    /////////
    return data;
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
    data = [[NSMutableArray alloc] initWithContentsOfFile:docFileName];
}

- (void)saveDataToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *docFileName = [[NSString alloc] initWithFormat:@"%@/Todo.sav", docPath];
    [data writeToFile:docFileName atomically:YES];
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
