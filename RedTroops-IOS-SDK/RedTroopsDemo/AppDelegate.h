//
//  AppDelegate.h
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import <UIKit/UIKit.h>


int x(int y);

@class ViewController;
extern NSNumber *omar;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
