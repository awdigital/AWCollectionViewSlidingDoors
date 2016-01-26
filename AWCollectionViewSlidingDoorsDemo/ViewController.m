//
//  ViewController.m
//  AWCollectionViewSlidingDoorsDemo
//
//  Created by Antoine Wette on 26.01.16.
//  Copyright © 2016 Antoine Wette. All rights reserved.
//

#import "ViewController.h"
#import "AWCollectionViewSlidingDoorLayout.h"
#import "GalleryCell.h"

#define cellID @"galleryCellID"
#define cellID2 @"galleryCellID2"
#define defaultMinRatio 6
#define defaultMaxRatio 1.5

@interface ViewController ()

@end

@implementation ViewController{
    NSString *currentStyle;
    UIView *menuOverlay;
    
    UILabel *minRatioLabel;
    UISlider *minRatioSlider;
    UILabel *maxRatioLabel;
    UISlider *maxRatioSlider;
    
    CGFloat minRatio;
    CGFloat maxRatio;
    
    UISegmentedControl *exampleSwitch;
    AWCollectionViewSlidingDoorLayout *slidingLayout;
    int exampleIndex;
}

@synthesize collectionView, items;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentStyle = @"style1";
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"gallery" ofType:@"json"];
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:jsonPath];
    items = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    minRatio = defaultMinRatio;
    maxRatio = defaultMaxRatio;
    exampleIndex = 0;
    
    [collectionView registerNib:[UINib nibWithNibName:@"galleryCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellID];
    [collectionView registerNib:[UINib nibWithNibName:@"galleryCell2" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellID2];
    slidingLayout = [[AWCollectionViewSlidingDoorLayout alloc] initWithMaxRatio:defaultMaxRatio andMinRatio:defaultMinRatio];
    [collectionView setCollectionViewLayout:slidingLayout];
    [collectionView.collectionViewLayout invalidateLayout];
    
    [self buildSettings];
    [self performSelector:@selector(quickFix) withObject:nil afterDelay:0.01];
}

-(void)buildSettings{
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"settings_view" owner:self options:nil];
    menuOverlay = [viewArr objectAtIndex:0];
    menuOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:menuOverlay];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"view": menuOverlay}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"view": menuOverlay}]];
    menuOverlay.alpha = 0;
    menuOverlay.hidden = YES;
    
    minRatioLabel = (UILabel*)[menuOverlay viewWithTag:100];
    minRatioSlider = (UISlider*)[menuOverlay viewWithTag:200];
  
    [minRatioSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    maxRatioLabel = (UILabel*)[menuOverlay viewWithTag:101];
    maxRatioSlider = (UISlider*)[menuOverlay viewWithTag:201];
    [maxRatioSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    exampleSwitch = (UISegmentedControl*)[menuOverlay viewWithTag:203];
    [exampleSwitch addTarget:self action:@selector(switchExample) forControlEvents:UIControlEventValueChanged];
}

-(void)updateDialSettings{
    minRatio = minRatioSlider.value;
    maxRatio = maxRatioSlider.value;
    
    [minRatioLabel setText:[NSString stringWithFormat:@"Min Ratio: %0.2f", minRatio]];
    
    [maxRatioLabel setText:[NSString stringWithFormat:@"Max Ratio: %0.2f", maxRatio]];
    
    [slidingLayout setMinRatio:minRatio];
    [slidingLayout setMaxRatio:maxRatio];
    
    
    [slidingLayout invalidateLayout];
}

-(void)switchExample{
    exampleIndex = (int)exampleSwitch.selectedSegmentIndex;
    [collectionView reloadData];
    [self performSelector:@selector(quickFix) withObject:nil afterDelay:0.01];
}

-(void)showMenu:(id)sender{
    menuOverlay.alpha = 0;
    menuOverlay.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        menuOverlay.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}
-(void)closeMenu:(id)sender{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        menuOverlay.alpha = 0;
    } completion:^(BOOL finished) {
        menuOverlay.hidden = YES;
    }];
}

-(void)quickFix{
    [collectionView setContentOffset:CGPointMake(0, collectionView.contentOffset.y+1)];
}

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
        
        
        if(exampleIndex == 0){
            cell.overlayView.alpha = 1 - alpha;
            cell.titleLabel.alpha = alpha;
        }else{
            cell.overlayView.alpha = 1 - alpha;
            cell.titleLabel.alpha = alpha;
            cell.subtitleLabel.alpha = alpha;
            if(i > currentIndex){
                cell.titleLabel.transform = CGAffineTransformMakeScale(1 - (1- alpha) * 0.3, 1 - (1- alpha) * 0.3);
                cell.subtitleLabel.transform = CGAffineTransformMakeTranslation(0, (1- alpha) * 30);
            }else{
                cell.titleLabel.transform = CGAffineTransformIdentity;
                cell.subtitleLabel.transform = CGAffineTransformIdentity;
            }
        }
       
    }
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *itemDict = [items objectAtIndex:indexPath.item];
    
    GalleryCell *cell;
    if(exampleIndex == 0){
        cell = (GalleryCell*)[cv dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    }else{
        cell = (GalleryCell*)[cv dequeueReusableCellWithReuseIdentifier:cellID2 forIndexPath:indexPath];
    }
    
    cell.titleLabel.text = [[itemDict valueForKey:@"title"] uppercaseString];
    cell.subtitleLabel.text = [itemDict valueForKey:@"subtitle"];
    cell.imageView.image = [UIImage imageNamed:[itemDict valueForKey:@"image"]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return items.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
