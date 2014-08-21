//
//  RedTroopsBanner.h
//  RedTroopsDemo
//
//  Created by Omar on 9/28/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RedTroopsBanner : NSObject

@property (nonatomic, strong) NSString *bannerID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) CGSize bannerSize;
@property (nonatomic, strong) NSString *bannerType;

@end
