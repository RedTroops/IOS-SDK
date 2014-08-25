//
//  ViewController.m
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import "ViewController.h"
#import "RedTroops.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)registerPushNotification:(id)sender
{
   // 1.1
  //  [RedTroops handlePushRegistration:[@":<Enter-Your-Device-Token-Here-For-Testing>" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (IBAction)startSession:(id)sender {
    // 2.1
  //  [RedTroops applicationDidEnterBackground];//startSession:@"OpjFdYiCEaEUsrLL8AAzpNYx19TSAY1d" AppId:@"4" andDeviceType:@"ios"];
}



- (IBAction)showHTMLPopUp:(id)sender
{
    // 3.1
    [RedTroops showHTML5ImagePopup:self];
}


- (IBAction)showBannerList:(id)sender {
    
    [RedTroops showBannerListWithView:self];
//    // 4.1

}



@end
