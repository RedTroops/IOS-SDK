//
//  RTNagView.h
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RTNagView : UIView <UIWebViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,retain) NSDictionary *popUpParam;

- (void)showInView:(UIView*)view;
@end
