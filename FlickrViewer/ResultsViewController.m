//
//  ViewController.m
//  FlickrViewer
//
//  Created by Georgiy Kassabli on 3/3/18.
//  Copyright © 2018 Georgiy Kassabli. All rights reserved.
//

#import "ResultsViewController.h"

#import "FlickrViewModel.h"
#import "ResultsDataSource.h"
#import "ResultsSearchBar.h"

@interface ResultsViewController () <UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
@end

@implementation ResultsViewController {
  ResultsDataSource *_dataSource;
  ResultsSearchBar *_searchBar;
  UICollectionView *_collectionView;
  NSTimer *_loadMoreTimer;
  __weak FlickrViewModel *_viewModel;
}

- (instancetype)initWithViewModel:(FlickrViewModel *)viewModel
{
  if (self = [super init]) {
    self.title = @"Flickr viewer";
    _viewModel = viewModel;
  }
  return self;
}

- (void)loadView
{
  [super loadView];
  
  UIView *rootView = self.view;
  
  CGFloat searchBarHeight = 60;
  _searchBar = [[ResultsSearchBar alloc] initWithFrame:CGRectMake(0, 0, rootView.frame.size.width, searchBarHeight)];
  _searchBar.delegate = self;
  [self.view addSubview:_searchBar];
  
  CGFloat spacing = 10;
  CGFloat itemWidth = (rootView.frame.size.width - spacing * 2) / 3;
  CGFloat collectionViewHeight = rootView.frame.size.height - searchBarHeight;
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
  [flowLayout setMinimumInteritemSpacing:spacing];
  [flowLayout setMinimumLineSpacing:spacing];
  [flowLayout setItemSize:CGSizeMake(itemWidth, itemWidth)];
  
  _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, searchBarHeight, rootView.frame.size.width, collectionViewHeight) collectionViewLayout:flowLayout];
  [self.view addSubview:_collectionView];
}

- (void)viewLayoutMarginsDidChange
{
  [super viewLayoutMarginsDidChange];

  UIView *rootView = self.view;
  
  _searchBar.frame = CGRectMake(0, rootView.layoutMargins.top, rootView.frame.size.width, _searchBar.frame.size.height);
  _collectionView.frame = CGRectMake(0, rootView.layoutMargins.top + _searchBar.frame.size.height,
                                     rootView.frame.size.width, rootView.frame.size.height - _searchBar.frame.size.height - rootView.layoutMargins.top);
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _collectionView.backgroundColor = [UIColor whiteColor];
  _collectionView.delegate = self;
  
  _dataSource = [[ResultsDataSource alloc] initWithCollectionView:_collectionView viewModel:_viewModel];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if( scrollView.contentSize.height == 0 ) {
    return ;
  }
  if (scrolledToBottomWithBuffer(scrollView.contentOffset, scrollView.contentSize, scrollView.contentInset, scrollView.bounds) && !_loadMoreTimer) {
    [_viewModel loadMoreResults];
    _loadMoreTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer * _Nonnull timer) {
      [timer invalidate];
      _loadMoreTimer = nil;
    }];
  }
}

static BOOL scrolledToBottomWithBuffer(CGPoint contentOffset, CGSize contentSize, UIEdgeInsets contentInset, CGRect bounds)
{
  CGFloat buffer = CGRectGetHeight(bounds) - contentInset.top - contentInset.bottom;
  const CGFloat maxVisibleY = (contentOffset.y + bounds.size.height);
  const CGFloat actualMaxY = (contentSize.height + contentInset.bottom);
  return ((maxVisibleY + buffer) >= actualMaxY);
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
  [_collectionView setContentOffset:CGPointZero animated:YES];
  [_viewModel searchTermDidChange:searchText];
}

@end
