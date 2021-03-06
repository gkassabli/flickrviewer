//
//  ViewController.h
//  FlickrViewer
//
//  Created by Georgiy Kassabli on 3/3/18.
//  Copyright © 2018 Georgiy Kassabli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrViewModel;

@interface ResultsViewController : UIViewController

- (instancetype)initWithViewModel:(FlickrViewModel *)viewModel;

@end

