//
//  ResultsCollectionViewCell.m
//  FlickrViewer
//
//  Created by Georgiy Kassabli on 3/3/18.
//  Copyright © 2018 Georgiy Kassabli. All rights reserved.
//

#import "ResultsCollectionViewCell.h"

@implementation ResultsCollectionViewCell {
  UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.frame = self.contentView.frame;
    [self.contentView addSubview:_imageView];
  }
  return self;
}

- (void)prepareForReuse
{
  _imageView.frame = self.contentView.frame;
  _imageView.image = nil;
}

- (void)setImage:(UIImage *)image
{
  _imageView.image = image;
}

@end
