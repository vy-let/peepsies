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
@property (nonatomic, strong) NSArray *photos;

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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rootThum" forIndexPath:indexPath];
    
    if(!cell)
    {
        NSLog(@"cell not created");
    }
    
 //   [cell.setImage: self.photos[indexPath]]; 
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.thumbnailsView registerClass:[PPPostThumbnail class] forCellWithReuseIdentifier:@"rootThum"];
    
    self.photos = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"mario"],
                      [UIImage imageNamed:@"smile"],
                      [UIImage imageNamed:@"cupcake"],
                      [UIImage imageNamed:@"sulley"],
                      [UIImage imageNamed:@"tricolor"], nil ];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
