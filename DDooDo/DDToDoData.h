//
//  DDToDoData.h
//  DDooDo
//
//  Created by Sangsoo Park on 12. 3. 7..
//  Copyright (c) 2012년 nobird01@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDToDoData : NSObject
{
    NSMutableArray *data;
}

- (NSMutableArray *)Items;
- (void)loadData;
- (void)saveData;
@end

@interface DDTodoItem : NSObject
{
    NSDate *date;
    NSString *title;
    BOOL isChecked;
    NSString *identifier;
}
@end
