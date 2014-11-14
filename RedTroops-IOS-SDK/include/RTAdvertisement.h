//
//  RTAdvertisement.h
//  iOSSDK
//
//  Created by Rami Arafat
//  Copyright (c) 2014 RedTroops. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTAdvertisement : NSObject

@property (nonatomic, assign) NSInteger adId;
@property (nonatomic, strong) NSString *adUrl;
@property (nonatomic, strong) NSString *targetUrl;
@property (nonatomic, assign) NSInteger refreshRate;
@property (nonatomic, strong) NSString *term;

-(id)initWithAttributes:(NSDictionary *)attributes;

@end
