//
//  DDMainViewController.m
//  DDooDo
//
//  Created by 기찬 남 on 12. 3. 8..
//  Copyright (c) 2012년 nobird01@gmail.com. All rights reserved.
//

#import "DDMainViewController.h"

@interface DDMainViewController ()
{
    NSMutableArray *_objects;
}
@property (strong, nonatomic) IBOutlet UITextField *todoTextField;
@property (strong, nonatomic) IBOutlet UITableView *todoTableView;
@property (strong, nonatomic) IBOutlet UILabel *todayLabel;
@end

@implementation DDMainViewController
@synthesize todoTextField;
@synthesize todoTableView;
@synthesize todayLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTime:) userInfo:nil repeats:YES]; 
    
    [todayLabel setFont:[UIFont fontWithName:@"Nanum Pen Script" size:20]];

    [self displayDate];
}

- (void)viewDidUnload
{

    [self setTodoTableView:nil];
    [self setTodoTextField:nil];
    [self setTodayLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// 3초마다 불려오는 메서드 
- (void) onTime:(NSTimer *)timer {
    [self displayDate];
 
}

- (void) displayDate {
    NSLocale *locale = [NSLocale currentLocale];
    //NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]; // 2012. 3. 8.
    //NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; // 3/8/2012
    //NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]; // 8/3/2012
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // 초기화
    [dateFormatter setLocale:locale]; // 현재 장비 설정 로케일 적용
    
    // 날짜 구하기
    
    // 월/일 순서를 템플릿을 통해서 바르게 얻어오도록 한다. 
    // 3월 8일의 표현법 미국식 3/9/2012 , 영국식 9/3/2012, 한국식 2012. 3. 9.
    NSString *dateComponents = @"y/M/d";
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:locale];
    
    dateFormatter.dateFormat= dateFormat;    
    NSString *dateOfLocale = [[dateFormatter stringFromDate:[NSDate date]] capitalizedString];
    
    //요일 구하기
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *weekday = [dateFormatter stringFromDate:[NSDate date]];
    
    self.todayLabel.text = [NSString stringWithFormat:@"%@ %@", dateOfLocale, weekday];   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.todoTextField resignFirstResponder];
}

- (IBAction)textfieldDone:(UITextField *)sender {
    [self insertNewObject:sender.text];
}
- (IBAction)editButtonTouchDown:(UIButton *)sender {
    if (self.todoTableView.isEditing)
        [self.todoTableView setEditing:FALSE animated:TRUE];
    else
        [self.todoTableView setEditing:TRUE animated:TRUE];
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    int curPosition = _objects.count;
    
    [_objects insertObject:sender atIndex:curPosition];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:curPosition inSection:0];
    [self.todoTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        
    }
    NSString *object = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = object;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     NSObject *o = [_objects objectAtIndex:fromIndexPath.row];
     
     if(toIndexPath.row > fromIndexPath.row) //moving a row down
         for(int x = toIndexPath.row; x > fromIndexPath.row; x--)
             [_objects replaceObjectAtIndex:x-1 withObject:[_objects objectAtIndex:x]];
     else //moving a row up
         for(int x = toIndexPath.row; x < fromIndexPath.row; x++)
             [_objects replaceObjectAtIndex:x+1 withObject:[_objects objectAtIndex:x]];
     
     [_objects replaceObjectAtIndex:toIndexPath.row withObject:o];
     
     [tableView reloadData];
 }

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }


@end
