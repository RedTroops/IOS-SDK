//
//  RTAdSize.h
//  iOSSDK
//
//  Created by RedTroops
//  Copyright (c) 2014 RedTroops. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef struct RTAdType {
    //CGSize size;
    int id;
    __unsafe_unretained NSString *type;
} RTAdType;




extern RTAdType const RTAdBannerTop;
extern RTAdType const RTAdBannerBottom;
extern RTAdType const RTAdPopUp;
extern RTAdType const RTAdNative1to1;
extern RTAdType const RTAdNative1to6;
extern RTAdType const RTAdNative6to1;



