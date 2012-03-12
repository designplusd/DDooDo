//
//  DDMainViewController.h
//  DDooDo
//
//  Created by 기찬 남 on 12. 3. 8..
//  Copyright (c) 2012년 nobird01@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCustomCell.h"
#import "DDToDoData.h"
#import <iAd/iAd.h>

@interface DDMainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    ADBannerView *banner;
    // int tapCount;
}

@property (nonatomic, assign)BOOL bannerIsVisible;
@property (nonatomic, retain)IBOutlet ADBannerView *banner; 

- (void) drawCell: (DDCustomCell*) cell : (NSIndexPath*) indexPath; 
 
//@property (nonatomic) int tapCount;

@end



