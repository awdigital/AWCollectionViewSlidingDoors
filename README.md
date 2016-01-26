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
