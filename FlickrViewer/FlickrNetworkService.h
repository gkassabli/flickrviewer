//
//  FlickrNetworkService.h
//  FlickrViewer
//
//  Created by Georgiy Kassabli on 3/3/18.
//  Copyright © 2018 Georgiy Kassabli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrImage : NSObject

@property (nonatomic, readonly) NSString *imageId;

@end

@interface FlickrNetworkService : NSObject

- (void)getImagesForTerm:(NSString *)searchTerm page:(int)page completion:(void (^)(NSArray <FlickrImage *> *))completionBlock;
- (void)getImage:(FlickrImage *)image completion:(void (^)(NSData *data))completionBlock;

@end
