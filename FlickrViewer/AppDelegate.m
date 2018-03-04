//
//  AppDelegate.m
//  FlickrViewer
//
//  Created by Georgiy Kassabli on 3/3/18.
//  Copyright © 2018 Georgiy Kassabli. All rights reserved.
//

#import "AppDelegate.h"

#import "ResultsViewController.h"
#import "FlickrViewModel.h"

@implementation AppDelegate {
  UIWindow *_window;
  FlickrViewModel *_viewModel;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  _viewModel = [FlickrViewModel new];
  ResultsViewController *viewController = [[ResultsViewController alloc] initWithViewModel:_viewModel];
  
  [_window setRootViewController:[[UINavigationController alloc] initWithRootViewController:viewController]];
  [_window makeKeyAndVisible];
  return YES;
}

@end
