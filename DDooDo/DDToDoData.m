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

- (void)loadToDoData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *docFileName = [[NSString alloc] initWithFormat:@"%@/Todo.sav", docPath];
    
    NSLog(@"Load Todo Data from file");
    data = [[NSMutableArray alloc] initWithContentsOfFile:docFileName];
}

- (void)saveTodoData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *docFileName = [[NSString alloc] initWithFormat:@"%@/Todo.sav", docPath];
    [data writeToFile:docFileName atomically:YES];
}


@end
