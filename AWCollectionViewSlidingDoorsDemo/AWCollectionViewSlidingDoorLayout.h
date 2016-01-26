//
//  AWCollectionViewSlidingDoorLayout.h
//  BERS
//
//  Created by Antoine Wette on 31.03.15.
//  Copyright (c) 2015 Antoine Wette. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWCollectionViewSlidingDoorLayout : UICollectionViewLayout

@property (readwrite, nonatomic, assign) int cellCount;
@property (readwrite, nonatomic, assign) CGFloat maxRatio;
@property (readwrite, nonatomic, assign) CGFloat minRatio;
@property (readwrite, nonatomic, assign) CGFloat maxHeight;
@property (readwrite, nonatomic, assign) CGFloat minHeight;
@property (readwrite, nonatomic, assign) CGFloat cellHeight;

-(id)initWithMaxRatio: (CGFloat)maxR andMinRatio: (CGFloat)minR;
@end

@protocol AWCollectionViewDelegateSlidingDoorLayout <UICollectionViewDelegate>
@required
/**
 *
 */
- (void)layoutSubviewsWithAttributes:(NSMutableArray*)theAttributes;
@end
