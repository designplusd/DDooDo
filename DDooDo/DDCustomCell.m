//
//  DDCustomCell.m
//  DDooDo
//
//  Created by 기찬 남 on 12. 3. 9..
//  Copyright (c) 2012년 nobird01@gmail.com. All rights reserved.
//

#import "DDCustomCell.h"

@implementation DDCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
