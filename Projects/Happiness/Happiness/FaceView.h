//
//  FaceView.h
//  Happiness
//
//  Created by 동인 이 on 12. 3. 8..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FaceView;

@protocol FaceViewDataSource

- (float)smileForFaceView:(FaceView *)sender;

@end 

@interface FaceView : UIView

@property (nonatomic) CGFloat scale;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@property (nonatomic, weak) IBOutlet id <FaceViewDataSource> dataSource;
@end
