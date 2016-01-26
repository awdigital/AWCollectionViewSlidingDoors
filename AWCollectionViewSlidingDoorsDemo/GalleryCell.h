//
//  GalleryCell.h
//  AWCollectionViewSlidingDoorsDemo
//
//  Created by Antoine Wette on 26.01.16.
//  Copyright © 2016 Antoine Wette. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIView *overlayView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, strong) IBOutlet UIView *subtitleWrapper;
@end
