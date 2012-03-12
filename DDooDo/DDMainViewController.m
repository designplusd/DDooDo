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
    DDToDoData *todoData;
}

@property (strong, nonatomic) IBOutlet UITextField *todoTextField;
@property (strong, nonatomic) IBOutlet UITableView *todoTableView;
@property (strong, nonatomic) IBOutlet UILabel *todayLabel;
@end

@implementation DDMainViewController
@synthesize todoTextField;
@synthesize todoTableView;
@synthesize todayLabel;

@synthesize banner, bannerIsVisible;

int tapCount, tappedRow, doubleTapRow;
NSTimer* tapTimer;

int modifyingRow;

- (void) bannerViewDidLoad:(ADBannerView *)abanner{
    if(!self.bannerIsVisible){
        [UIView beginAnimations:@"animatedAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame,0.0 , 50.0);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void) bannerView:(ADBannerView *)aBanner didFailToReceiveAdWithError:(NSError *)error{
    if(!self.bannerIsVisible){
        [UIView beginAnimations:@"animatedAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame,0.0 , -320.0);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}


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
    
    [todayLabel setFont:[UIFont fontWithName:@"Nanum Pen Script" size:24.0f]];
    [todoTextField setFont:[UIFont fontWithName:@"Nanum Pen Script" size:22.0f]];
    
    todoData = [[DDToDoData alloc]init];
    [todoData loadData];
    
    [self displayDate];
}

- (void)viewDidUnload
{
    [self setTodoTableView:nil];
    [self setTodoTextField:nil];
    [self setTodayLabel:nil];
    
    [todoData saveData];
    todoData = nil;
    
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
    return YES;
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.todoTextField resignFirstResponder];
}

- (IBAction)textfieldDone:(UITextField *)sender {
    
    if(sender.text.length == 0)
    {
        return;
    }
    
    if(todoTableView.isEditing == FALSE)
    {
        [self insertNewObject:sender.text];
    }
    else 
    {
        [self modifyObject:sender];
    }
}
- (IBAction)editButtonTouchDown:(UIButton *)sender {
    if (self.todoTableView.isEditing){
        [self.todoTableView setEditing:FALSE animated:TRUE];
    }
    else{
        [self.todoTableView setEditing:TRUE animated:TRUE];
    }
    
    [todoTableView reloadData];
}

- (void)insertNewObject:(id)sender
{
    int curPosition = todoData.count;

    [todoData insertItem:curPosition : [NSDate date] : sender : FALSE];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:curPosition inSection:0];
    [self.todoTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [todoData saveData];
    
    // 입력창 초기화
    todoTextField.text = @"";
}

- (void)modifyObject:(UITextField *)sender
{
    if(todoTableView.isEditing == TRUE)
    {
        [todoData getItem:modifyingRow].title = sender.text;
        [todoTableView setEditing:NO animated:YES];
        
        [todoTableView reloadData];
        [todoData saveData];
        
        // 입력창 초기화
        todoTextField.text = @"";
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return todoData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDCustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    [self drawCell:customCell :indexPath];
    
    // 수정 버튼을 누를때 사용하기 위해 row를 넣어둔다.
    customCell.modifyButton.tag = indexPath.row;

    return customCell;
}

- (void) drawCell: (DDCustomCell*) cell : (NSIndexPath*) indexPath
{
    // 할일 표시하기
    [cell.todoLabel setFont:[UIFont fontWithName:@"Nanum Pen Script" size:20]];
    cell.todoLabel.text = [todoData getItem:(indexPath.row)].title;
    
    
    // 취소선 그리기
    
    if([todoData getItem:(indexPath.row)].isChecked == YES)
    {
        cell.strikeThroughImage.alpha = 0.5;
        
        CGSize textLabelSize = [cell.todoLabel.text sizeWithFont:cell.todoLabel.font /*constrainedToSize:constrainedSize*/];
        
        NSLog(@"text label width: %f", textLabelSize.width);
        
        CGRect frame = cell.strikeThroughImage.frame;
        frame.size.width = textLabelSize.width;
        cell.strikeThroughImage.frame = frame;
    }
    else 
    {
        cell.strikeThroughImage.alpha = 0;
    }
    
    // 수정 버튼 표시하기
    if(todoTableView.isEditing == YES)
    {
        [cell.modifyButton setHidden:NO];
    }
    else
    {
        [cell.modifyButton setHidden:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        [todoData removeItem:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } 
    else if (editingStyle == UITableViewCellEditingStyleInsert) 
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     int fromIndex = fromIndexPath.row;
     int toIndex = toIndexPath.row;
     
     if (fromIndex == toIndex)
         return;
     
     id tmpItem = [todoData getItem:fromIndex];
     [todoData removeItem:fromIndex];
     [todoData insertItem:toIndex : tmpItem];

     [tableView reloadData];
     [todoData saveData];
 }

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }

 - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
 {
     DDCustomCell *cell = (DDCustomCell *) [tableView cellForRowAtIndexPath:indexPath];
     
     // checking for double taps here
     if (tapCount == 1 && tapTimer != nil && tappedRow == indexPath.row)
     {
         // double tap - Put your double tap code here
         [tapTimer invalidate];
         tapTimer = nil;
         
         doubleTapRow = tappedRow;
         
         [cell setSelected:NO animated:YES];  // maybe, maybe not
         
         // 취소 데이터 반전
         if([todoData getItem:(indexPath.row)].isChecked == YES){
             [todoData getItem:(indexPath.row)].isChecked = NO;
         }
         else {
             [todoData getItem:(indexPath.row)].isChecked = YES;
         }
         
         // 취소선 그리기
         [self drawCell:cell :indexPath];
  
         tapCount = 0;
         tappedRow = -1;
     }
     else if (tapCount == 0)
     {
         // This is the first tap. If there is no tap till tapTimer is fired, it is a single tap
         tapCount = 1;
         tappedRow = indexPath.row;
         tapTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self 
                                                   selector:@selector(tapTimerFired:) 
                                                   userInfo:nil repeats:NO];
     }
     else if (tappedRow != indexPath.row)
     {
         // tap on new row
         tapCount = 0;
         if (tapTimer != nil)
         {
             [tapTimer invalidate];
             tapTimer = nil;
         }
     }
 }

- (void)tapTimerFired:(NSTimer *)aTimer{
    if (tapTimer != nil)
    {
        tapCount = 0;
        tappedRow = -1;
    }
}

- (IBAction)cellModifyTouched:(UIButton *)sender {
    modifyingRow = sender.tag;
    
    [todoTextField becomeFirstResponder];
    todoTextField.text = [todoData getItem:modifyingRow].title;
    
    NSLog(@"Selected row: %d", sender.tag);
}


@end
