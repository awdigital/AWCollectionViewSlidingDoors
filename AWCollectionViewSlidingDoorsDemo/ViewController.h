//
//  ViewController.h
//  AWCollectionViewSlidingDoorsDemo
//
//  Created by Antoine Wette on 26.01.16.
//  Copyright © 2016 Antoine Wette. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

- (IBAction)showMenu:(id)sender;
- (IBAction)closeMenu:(id)sender;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *editBtn;
@property NSArray *items;@end

