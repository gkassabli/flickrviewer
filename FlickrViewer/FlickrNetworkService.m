//
//  FlickrNetworkService.m
//  FlickrViewer
//
//  Created by Georgiy Kassabli on 3/3/18.
//  Copyright © 2018 Georgiy Kassabli. All rights reserved.
//

#import "FlickrNetworkService.h"

#define kFlickrSearchKey @"167ed2d84217bb38f4ece8bf1cb8ea1a"
#define kImagesPerPage 20

@interface FlickrImage ()

- (instancetype)initWithImageId:(NSString *)imageId farm:(NSString *)farm server:(NSString *)server secret:(NSString *)secret;

@property (nonatomic, readonly) NSString *farm;
@property (nonatomic, readonly) NSString *server;
@property (nonatomic, readonly) NSString *secret;

@end

@implementation FlickrImage

- (instancetype)initWithImageId:(NSString *)imageId farm:(NSString *)farm server:(NSString *)server secret:(NSString *)secret
{
  if (self = [super init]) {
    _imageId = imageId;
    _farm = farm;
    _server = server;
    _secret = secret;
  }
  return self;
}

@end

@implementation FlickrNetworkService

- (void)getImagesForTerm:(NSString *)searchTerm page:(int)page completion:(void (^)(NSArray<FlickrImage *> *))completionBlock
{
  NSString *escapedSearchTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
  NSString *searchRequest = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=%d&page=%i&format=json&nojsoncallback=1",
                             kFlickrSearchKey, escapedSearchTerm, kImagesPerPage, page];
  [[[NSURLSession sharedSession] dataTaskWithURL:[[NSURL alloc] initWithString:searchRequest]
                               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (error) {
      completionBlock(nil);
    } else {
      NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
      NSMutableArray *images = [NSMutableArray new];
      if (!error) {
        NSArray *photos = result[@"photos"][@"photo"];
        for (NSDictionary *photoDictionary in photos) {
          FlickrImage *image = [[FlickrImage alloc] initWithImageId:photoDictionary[@"id"]
                                                               farm:photoDictionary[@"farm"]
                                                             server:photoDictionary[@"server"]
                                                             secret:photoDictionary[@"secret"]];
          [images addObject:image];
        }
      }
      completionBlock(images);
    }
  }] resume];
}

- (void)getImage:(FlickrImage *)image completion:(void (^)(NSData *))completionBlock
{
  NSString *imageRequest = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_m.jpg",
                             image.farm, image.server, image.imageId, image.secret];
  [[[NSURLSession sharedSession] dataTaskWithURL:[[NSURL alloc] initWithString:imageRequest]
                               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (error) {
      completionBlock(nil);
    } else {
      completionBlock(data);
    }
  }] resume];
}

@end
