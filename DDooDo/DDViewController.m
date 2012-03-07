//
//  DDViewController.m
//  DDooDo
//
//  Created by Sangsoo Park on 12. 3. 7..
//  Copyright (c) 2012년 nobird01@gmail.com. All rights reserved.
//

#import "DDViewController.h"

@interface DDViewController ()
{
    NSMutableArray *_todoDatas;
}
@end

@implementation DDViewController


- (void)loadToDoData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *docFileName = [[NSString alloc] initWithFormat:@"%@/Todo.sav", docPath];
    
    NSLog(@"Load Todo Data from file");
    _todoDatas = [[NSMutableArray alloc] initWithContentsOfFile:docFileName];
}

- (void)saveTodoData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *docFileName = [[NSString alloc] initWithFormat:@"%@/Todo.sav", docPath];
    [_todoDatas writeToFile:docFileName atomically:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Program Start");
    
    [self loadToDoData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
