//
//  FlickrViewModel.m
//  FlickrViewer
//
//  Created by Georgiy Kassabli on 3/3/18.
//  Copyright © 2018 Georgiy Kassabli. All rights reserved.
//

#import "FlickrViewModel.h"

#import "FlickrNetworkService.h"

@implementation FlickrViewModel {
  FlickrNetworkService *_networkService;
  NSString *_currentSearchTerm;
  int _currentPage;
  NSMutableArray<FlickrImage *> *_images;
  NSHashTable *_listeners;
  NSMutableDictionary<NSString *, UIImage *> *_imageCache;
}

- (instancetype)init
{
  if (self = [super init]) {
    _networkService = [FlickrNetworkService new];
    _images = [NSMutableArray new];
    _listeners = [NSHashTable weakObjectsHashTable];
    _imageCache = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void)addListener:(id<FlickrViewModelListener>)listener
{
  [_listeners addObject:listener];
}

- (void)removeListener:(id<FlickrViewModelListener>)listener
{
  [_listeners removeObject:listener];
}

- (void)searchTermDidChange:(NSString *)searchTerm
{
  if (searchTerm != _currentSearchTerm) {
    [_imageCache removeAllObjects];
    _currentSearchTerm = searchTerm;
    _currentPage = 0;
    [self _queueSearch:^{
      [_images removeAllObjects];
    }];
  }
}

- (void)imageForFlickrImage:(FlickrImage *)flickrImage completion:(void (^)(UIImage *result))completion
{
  UIImage *cachedImage = _imageCache[flickrImage.imageId];
  if (cachedImage) {
    completion(cachedImage);
  } else {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [_networkService getImage:flickrImage completion:^(NSData *data) {
        UIImage *image = [UIImage imageWithData:data];
        _imageCache[flickrImage.imageId] = image;
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(image);
        });
      }];
    });
  }
}

- (void)loadMoreResults
{
  _currentPage++;
  [self _queueSearch:nil];
}

- (void)_queueSearch:(void (^)(void))preCompletionBlock
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [_networkService getImagesForTerm:_currentSearchTerm page:_currentPage completion:^(NSArray<FlickrImage *> *newImages) {
      if (preCompletionBlock) {
        preCompletionBlock();
      }
      [_images addObjectsFromArray:newImages];
      dispatch_async(dispatch_get_main_queue(), ^{
        for (id<FlickrViewModelListener> listener in _listeners) {
          [listener searchResultsDidUpdate];
        }
      });
    }];
  });
}

@end
