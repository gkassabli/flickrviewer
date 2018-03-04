//
//  ResultsDataSource.m
//  FlickrViewer
//
//  Created by Georgiy Kassabli on 3/3/18.
//  Copyright © 2018 Georgiy Kassabli. All rights reserved.
//

#import "ResultsDataSource.h"

#import "FlickrViewModel.h"
#import "ResultsCollectionViewCell.h"

static NSString *kCollectionCellView = @"kCollectionCellView";

@interface ResultsDataSource () <FlickrViewModelListener, UICollectionViewDataSource>
@end

@implementation ResultsDataSource {
  __weak FlickrViewModel *_viewModel;
  __weak UICollectionView *_collectionView;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView viewModel:(FlickrViewModel *)viewModel
{
  if (self = [super init]) {
    _collectionView = collectionView;
    [collectionView registerClass:[ResultsCollectionViewCell class]
       forCellWithReuseIdentifier:kCollectionCellView];
    
    _viewModel = viewModel;
    [_viewModel addListener:self];
  }
  collectionView.dataSource = self;

  return self;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  ResultsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellView forIndexPath:indexPath];
  FlickrImage *image = [[_viewModel images] objectAtIndex:indexPath.row];
  [_viewModel imageForFlickrImage:image completion:^(UIImage *result) {
    [cell setImage:result];
  }];
  return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [[_viewModel images] count];
}

#pragma mark - FlickrViewModelListener

- (void)searchResultsDidUpdate
{
  [_collectionView reloadData];
}

@end
