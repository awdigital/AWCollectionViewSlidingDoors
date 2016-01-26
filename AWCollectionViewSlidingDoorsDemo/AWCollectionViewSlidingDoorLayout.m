//
//  AWCollectionViewSlidingDoorLayout.m
//  BERS
//
//  Created by Antoine Wette on 31.03.15.
//  Copyright (c) 2015 Antoine Wette. All rights reserved.
//

#import "AWCollectionViewSlidingDoorLayout.h"

@interface AWCollectionViewSlidingDoorLayout ()
@property (nonatomic, weak) id <AWCollectionViewDelegateSlidingDoorLayout> delegate;
@end

@implementation AWCollectionViewSlidingDoorLayout

- (id)init
{
    if ((self = [super init]) != NULL)
    {
        [self setup];
    }
    return self;
}

- (id <AWCollectionViewDelegateSlidingDoorLayout> )delegate {
    return (id <AWCollectionViewDelegateSlidingDoorLayout> )self.collectionView.delegate;
}

-(id)initWithMaxRatio: (CGFloat)maxR andMinRatio: (CGFloat)minR{
    if ((self = [super init]) != NULL)
    {
        self.maxRatio = maxR;//420.0f;
        self.minRatio = minR;//(CGSize){ 220.0f, 80.0f };
        [self setup];
    }
    return self;
}

- (void)setup
{
    
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.cellCount = (int)[self.collectionView numberOfItemsInSection:0];
    self.maxHeight = self.collectionView.bounds.size.width / self.maxRatio;
    self.minHeight = self.collectionView.bounds.size.width / self.minRatio;
    self.cellHeight = (self.maxHeight*0.5 + self.minHeight*0.5);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return(YES);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *theLayoutAttributes = [NSMutableArray array];
    
    float firstItem = 0;//fmax(0 , floorf(minY / self.itemHeight) - 4 );
    float lastItem = self.cellCount-1;//fmin( self.cellCount-1 , floorf(maxY / self.itemHeight) );
    
    
    for( int i = firstItem; i <= lastItem; i++ ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [theLayoutAttributes addObject:theAttributes];
    }
    
    if ([self.delegate respondsToSelector:@selector(layoutSubviewsWithAttributes:)]) {
        [self.delegate layoutSubviewsWithAttributes:theLayoutAttributes];
    }
    
    return(theLayoutAttributes);
}

- (CGSize)collectionViewContentSize{
    const CGSize theSize = {
        .width = self.collectionView.bounds.size.width,
        .height = (self.cellCount-1) * self.cellHeight + self.collectionView.bounds.size.height,
    };
    return(theSize);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat currentIndex = self.collectionView.contentOffset.y / self.cellHeight;
    
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    theAttributes.center = CGPointMake(self.collectionView.center.x , self.maxHeight*0.5);

    CGAffineTransform translationT;
    
    
    CGFloat endTranslateOffset = 0;
    
    CGFloat endFactor1 = (self.collectionView.bounds.size.height - self.maxHeight) / self.minHeight;
    if(currentIndex + 1 > (self.cellCount - endFactor1)){
        CGFloat valA = (currentIndex + 1 - (self.cellCount  - endFactor1));
        CGFloat valB = valA / endFactor1;
        endTranslateOffset = (self.collectionView.bounds.size.height - self.maxHeight) * valB;
    }
    
    
    /*
    CGFloat endTranslateOffset = 0;
    CGFloat lastItemY = (self.cellHeight * (self.cellCount - 1))  - self.collectionView.bounds.size.height;
    
    if(self.collectionView.contentOffset.y > lastItemY){
        CGFloat maxEnd = self.collectionView.contentSize.height - lastItemY;
        CGFloat factorEnd = (self.collectionView.contentOffset.y - lastItemY) / maxEnd;
        endTranslateOffset = factorEnd * self.collectionView.bounds.size.height;
    }
     */
    
    if(indexPath.item > floor(currentIndex) && indexPath.item <= floor(currentIndex) + 1 ){
        CGFloat factorY = floor(currentIndex) + 1 - currentIndex;
        CGFloat factorSize = fabs(1 - factorY);
        theAttributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight + (factorSize * (self.maxHeight - self.minHeight) ));
        translationT = CGAffineTransformMakeTranslation(0 ,endTranslateOffset + self.collectionView.contentOffset.y + self.cellHeight * factorY);
    }else if(indexPath.item > floor(currentIndex) + 1){
        translationT = CGAffineTransformMakeTranslation(0 , endTranslateOffset+ self.collectionView.contentOffset.y +self.cellHeight +  (self.minHeight * fmax(0, ((float)indexPath.item-currentIndex-1))) );
        theAttributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight);
    }else if (indexPath.item <= floor(currentIndex) && indexPath.item > floor(currentIndex) - 1){
        CGFloat factorY = 1 - (floor(currentIndex) + 1 - currentIndex);
        CGFloat factorSize = fabs(1 - factorY);
        theAttributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight + (factorSize * (self.maxHeight - self.minHeight) ));
        translationT = CGAffineTransformMakeTranslation(0 , endTranslateOffset + self.collectionView.contentOffset.y - self.cellHeight * factorY);
    }else if(indexPath.item <= floor(currentIndex) - 1){
        theAttributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight);
        translationT = CGAffineTransformMakeTranslation(0 , endTranslateOffset + self.collectionView.contentOffset.y - self.cellHeight +  (self.minHeight * fmin(0, ((float)indexPath.item-currentIndex+1))) );
    }
   
    theAttributes.transform = translationT;
    theAttributes.zIndex = 1;
    return(theAttributes);
}

@end
