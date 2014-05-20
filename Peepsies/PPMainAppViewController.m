//
//  PPMainAppViewViewController.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/19/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMainAppViewController.h" 
#import "PPPostThumbnail.h"

@interface PPMainAppViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *thumbnailsView;

@end

@implementation PPMainAppViewController

- (id)init
{
    self = [super initWithNibName:@"PPMainAppView" bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rootThum" forIndexPath:indexPath];
    
    if(!cell)
    {
        NSLog(@"cell not created");
    }
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_thumbnailsView registerClass:[PPPostThumbnail class] forCellWithReuseIdentifier:@"rootThum"]; 
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
