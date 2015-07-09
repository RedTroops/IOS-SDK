//
//  RTAdSize.h
//  iOSSDK
//
//  Created by RedTroops
//  Copyright (c) 2014 RedTroops. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef struct RTAdType {
    int id;
    __unsafe_unretained NSString *type;
} RTAdType;


extern RTAdType const RTAdBannerTop;
extern RTAdType const RTAdBannerBottom;
extern RTAdType const RTAdPopUp;
extern RTAdType const RTAdNative;
extern RTAdType const RTAdAudio;
extern RTAdType const RTAdVideo;


