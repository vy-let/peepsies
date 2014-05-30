//
//  PPMainAppViewViewController.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/19/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMainAppViewController.h" 
#import "PPPostThumbnail.h"
#import "PPPostMessage.h"
#import "PPPicturePostMessage.h"
#import "PPNewPostCell.h"

@interface PPMainAppViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *thumbnailsView;
@property (nonatomic) NSMutableArray *photos;

@end

@implementation PPMainAppViewController

- (id)init
{
    self = [super initWithNibName:@"PPMainAppView" bundle:[NSBundle mainBundle]];
    if (self) {
        [self setTitle:@"Peepsies"];
        UIImage *gridImage = [UIImage imageNamed:@"PictureGridTemplate"];
        [[self tabBarItem] setImage:gridImage];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewPost:) name:@"PPShowNewPost" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewPost:) name:@"PPReceivedNewPost" object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count] + 1;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger thumbnailIndex = [indexPath row];
    
    if (thumbnailIndex == 0) {
        // Return the new-post cell, not a regular thumbnail.
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"rootNewPostThum" forIndexPath:indexPath];
    }
    
    PPPostThumbnail *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rootThum" forIndexPath:indexPath];
    if(!cell)
        NSLog(@"cell not created");
    
    [cell setThumbnail:[self.photos[indexPath.row - 1] image]];  // Subtract one from the cell index to get the correct image
    
    return cell;
}



- (void)receiveNewPost:(NSNotification *)note {
    PPPostMessage *newPost = [[note userInfo] objectForKey:@"PPPost"];
    if (![newPost isKindOfClass:[PPPicturePostMessage class]])
        return;
    
    [self addPhoto:newPost];
}



- (void)addPhoto:(PPPicturePostMessage *)picturePost {
    [_photos insertObject:picturePost atIndex:0];
    [_thumbnailsView reloadData];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.thumbnailsView registerClass:[PPPostThumbnail class] forCellWithReuseIdentifier:@"rootThum"];
    [self.thumbnailsView registerClass:[PPNewPostCell class] forCellWithReuseIdentifier:@"rootNewPostThum"];
    
    self.photos = [@[] mutableCopy];
    
    
    
}





@end
