# AWCollectionViewSlidingDoors
Custom UICollectionViewLayout to create a slick vertical sliding effect.

![awcollectionviewslidingdoors gif](http://www.antoinewette.com/github/awcollectionviewslidingdoors.gif)


## Usage
Import the Custom CollectionViewLayout
```Objective-C
#import "AWCollectionViewSlidingDoorLayout.h"
```

Create a new instance of the CollectionViewLayout and assign it to your collectionview
```Objective-C
AWCollectionViewSlidingDoorLayout *slidingLayout = [[AWCollectionViewSlidingDoorLayout alloc] initWithMaxRatio:1.5 andMinRatio:6];
[collectionView setCollectionViewLayout:slidingLayout];
```
You will need to define ratio (width/height) values for active and inactive states. MaxRatio is the ratio of your active Cell  and MinRatio the ratio of the inactive cells.

If you want to add custom animations to your UICollectionViewCell subviews overwrite the layoutSubviewsWithAttributes delegate and refer to the following code snippet

```Objective-C
-(void)layoutSubviewsWithAttributes:(NSMutableArray *)theAttributes{
    for(int i = 0; i < theAttributes.count; i++){
        GalleryCell *cell = (GalleryCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        CGFloat maxHeight = self.collectionView.bounds.size.width / maxRatio;
        CGFloat minHeight = self.collectionView.bounds.size.width / minRatio;
        CGFloat cellHeight = (maxHeight*0.5 + minHeight*0.5);
        CGFloat currentIndex = self.collectionView.contentOffset.y / cellHeight;
        
        CGFloat ratio = cell.bounds.size.width / cell.bounds.size.height;
        CGFloat maxDiff = minRatio - maxRatio;
        CGFloat diff = minRatio - ratio;
        
        CGFloat alpha = diff/maxDiff;
        
        //FADE-OUT THE BLACK OVERLAY WHEN THE CELL BECOMES ACTIVE
        cell.overlayView.alpha = 1 - alpha;
        
        //FADE-IN THE TITLE WHEN THE CELL BECOMES ACTIVE
        cell.titleLabel.alpha = alpha;
        
        //ANIMATE THE SUBVIEW WHEN THE CELL BECOMES ACTIVE
        if(i > currentIndex){
            cell.titleLabel.transform = CGAffineTransformMakeScale(1 - (1- alpha) * 0.3, 1 - (1- alpha) * 0.3);
            cell.subtitleLabel.transform = CGAffineTransformMakeTranslation(0, (1- alpha) * 30);
        }else{
            cell.titleLabel.transform = CGAffineTransformIdentity;
            cell.subtitleLabel.transform = CGAffineTransformIdentity;
        }
       
    }
}
```
