//
//  PPMainAppViewViewController.h
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/19/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPMainAppViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

- (void)addPhoto:(UIImage *)photoToDisplay;

@end
