//
//  DDToDoData.h
//  DDooDo
//
//  Created by Sangsoo Park on 12. 3. 7..
//  Copyright (c) 2012년 nobird01@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDTodoItem;

@interface DDToDoData : NSObject{
    NSMutableArray *_data;
}

//- (NSMutableArray *)Items;

- (void) insertItem: (int) index : (NSDate*) date : (NSString*) title : (BOOL) isChecked;

- (void) removeItem: (int) index;

- (DDTodoItem*) getItem: (int) index;

- (int) count;

- (void)loadToDoData;

- (void)saveTodoData;

@end

@interface DDTodoItem : NSObject
{
    NSDate *date;
    NSString *title;
    BOOL isChecked;
}

@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *title;
@property (nonatomic) BOOL isChecked;

@end
