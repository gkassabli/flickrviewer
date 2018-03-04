//
//  FlickrViewModel.h
//  FlickrViewer
//
//  Created by Georgiy Kassabli on 3/3/18.
//  Copyright © 2018 Georgiy Kassabli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrImage;

@protocol FlickrViewModelListener <NSObject>

- (void)searchResultsDidUpdate;

@end

@interface FlickrViewModel : NSObject

- (void)searchTermDidChange:(NSString *)searchTerm;
- (void)loadMoreResults;
- (void)imageForFlickrImage:(FlickrImage *)flickrImage completion:(void (^)(UIImage *result))completion;

- (void)addListener:(id<FlickrViewModelListener>)listener;
- (void)removeListener:(id<FlickrViewModelListener>)listener;

@property (nonatomic, readonly) NSArray<FlickrImage *> *images;

@end
