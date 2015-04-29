<p align="center">
<img src="http://redtroops.com/images/logo_large.png" alt="RedTroops" width="150px">
</p>


#RedTroops SDK 2.0 for IOS

Requirements: **IOS 6.0 +**

###Getting Started

RedTroops SDK 3.0 currently features:

**Push Notifications.**

**Send user spent time.**

**3 types of (HTML5/Image) ads.**


---------------
######[Cocos2d](https://github.com/RedTroops/IOS-SDK/wiki/Cocos2d---Cocos2d-x-Documentation), [Cocos2d-x](https://github.com/RedTroops/IOS-SDK/wiki/Cocos2d---Cocos2d-x-Documentation), and [Unity](https://github.com/RedTroops/Unity-SDK) documentation are available


---------------



**Setting Up RedTroops SDK 2.0 In Your Project**

Follow the steps below to get your RedTroops SDK 3.0 running:


1) Download the SDK from here.

2) Drag & Drop downloaded files (RedTroops.a + include) to your project.

3) Add following frameworks:

<ul>
<li>SystemConfiguration.framework</li>
<li>QuartzCore.framework</li>
<li>CoreGraphics.framework</li>
<li>Security.framework</li>
<li>MobileCoreServices.framework</li>
<li>CoreTelephony.framework</li>
</ul>


###Initial Setup

1) In your app delegate (AppDelegate.m), import RTSessionManager

```objective-c
    #import "RTSessionManager.h"
```


2) In your app delegate (AppDelegate.m), find the method

```objective-c
   - (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:
(NSDictionary*)launchOptions
```

and add the following line of code
```objective-c
    [[RTSessionManager defaultManager]startSessionWithAPIKey:@"Your API KEY"];
```
* Your API Key: You can find it in RedTroops administration panel.
  http://developer.dev.redtroops.com/app/index

3)  In your app delegate (AppDelegate.m), find the method

```objective-c
   - (void)applicationWillEnterForeground:(UIApplication*)application
```
and add the following line of code
```objective-c
     [[RTSessionManager defaultManager]startSessionWithAPIKey:@"Your API KEY"];
```

4) In your app delegate (AppDelegate.m), find the method

```objective-c
    - (void)applicationWillTerminate:(UIApplication *)application
```

and add the following line of code
```objective-c
    [[RTSessionManager defaultManager] endTheSession];
 ```
 
 5)   In your app delegate (AppDelegate.m), find the method
```objective-c
(void)applicationDidEnterBackground:(UIApplication *)application 
```
and add the following line of code

```objective-c
 [[RTSessionManager defaultManager] endTheSession];
```


---------------


####RedTroops offer 3 types of ads:

#####1. Banner  (  Top Screen Banner   - Bottom Screen Banner)

#####2. Interstitial

#####3. Native 



###1. Banner

######Before adding a banner:
In the targeted viewController.m , add these 2 properties

```objective-c
@property (nonatomic,assign) CGFloat heightOfScreen;
@property (nonatomic,assign) CGFloat widthOfScreen;
```

and the following method (this method will give the current screen width and height using any iOS)
```objective-c
-(void) getScreenSize
{
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    float osVERSION = [osVersion floatValue];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (osVERSION >= 8)
    {
        _heightOfScreen = screenHeight;
        _widthOfScreen = screenWidth;
    }
    else
    {
        UIInterfaceOrientation statusBarOrientation =[UIApplication sharedApplication].statusBarOrientation;
        if (statusBarOrientation==4||statusBarOrientation==3)
        {
            _heightOfScreen = screenWidth;
            _widthOfScreen = screenHeight;
        }
        else if (statusBarOrientation==1||statusBarOrientation==2)
        {
            _heightOfScreen = screenHeight;
            _widthOfScreen = screenWidth;
        }
    }
}
```

#####A. Top Screen Banner

1) Import the following file to your view controller

```objective-c
#import "RTAdView.h"
```
2) In the ViewController.m Interface 

```objective-c
@interface ViewController ()

@end
```
Add the following property

```objective-c
@property (nonatomic,strong) RTAdView *topBanner;
```

3) Add the following line to your view controller to show the ad

```objective-c
    [self getScreenSize];
    
    float widthOfAd;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        widthOfAd = _widthOfScreen*0.5;}
    else{
        widthOfAd = 320;}
    float heightOfAd = widthOfAd*(75.0/320);
    float xOfAd = (_widthOfScreen-widthOfAd)/2;
    float yOfAd = _heightOfScreen-heightOfAd;
    
    self.topBanner = [[RTAdView alloc] initWithSize:RTAdBannerTop];
    self.topBanner.frame = CGRectMake(xOfAd,0,widthOfAd,heightOfAd);
    [self.view addSubview:self.topBanner];
    [self.view bringSubviewToFront:self.topBanner];
    [self.topBanner prepareAd];
    [self.topBanner loadRequest];



    
```

#####B. Bottom Screen Banner

1) Import the following file to your view controller

```objective-c
#import "RTAdView.h"
```
2) In the ViewController.m Interface 

```objective-c
@interface ViewController ()

@end
```
Add the following property

```objective-c
@property (nonatomic,strong) RTAdView *bottomBanner;
```

3) Add the following line to your view controller to show the ad

```objective-c
    [self getScreenSize];
    
    float widthOfAd;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        widthOfAd = _widthOfScreen*0.5;}
    else{
        widthOfAd = 320;}
    float heightOfAd = widthOfAd*(75.0/320);
    float xOfAd = (_widthOfScreen-widthOfAd)/2;
    float yOfAd = _heightOfScreen-heightOfAd;
    
    self.bottomBanner = [[RTAdView alloc] initWithSize:RTAdBannerBottom];
    self.bottomBanner.frame = CGRectMake(xOfAd,yOfAd,widthOfAd,heightOfAd);
    [self.view addSubview:self.bottomBanner];
    [self.view bringSubviewToFront:self.bottomBanner];
    [self.bottomBanner prepareAd];
    [self.bottomBanner loadRequest];
    
```

###### Important notes

Note 1: Banner’s size and position are fixed, changing any will result in removing them from the view.

Note 2: Hidding the adView will result in deleting it. Instead use the following method.

```objective-c
 [self.adView removeTheAd];
```
---------------

###2. Interstitial 

######Before adding an Interstitial:
In the targeted viewController.m , add these 2 properties

```objective-c
@property (nonatomic,assign) CGFloat heightOfScreen;
@property (nonatomic,assign) CGFloat widthOfScreen;
```

and the following method (this method will give the current screen width and height using any iOS)
```objective-c
-(void) getScreenSize
{
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    float osVERSION = [osVersion floatValue];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (osVERSION >= 8)
    {
        _heightOfScreen = screenHeight;
        _widthOfScreen = screenWidth;
    }
    else
    {
        UIInterfaceOrientation statusBarOrientation =[UIApplication sharedApplication].statusBarOrientation;
        if (statusBarOrientation==4||statusBarOrientation==3)
        {
            _heightOfScreen = screenWidth;
            _widthOfScreen = screenHeight;
        }
        else if (statusBarOrientation==1||statusBarOrientation==2)
        {
            _heightOfScreen = screenHeight;
            _widthOfScreen = screenWidth;
        }
    }
}
```


1) Import the following file to your view controller
```objective-c
    #import "RTAdView.h"
```

2) In the ViewController.m Interface 

```objective-c
@interface ViewController ()

@end
```
Add the following property

```objective-c
@property (nonatomic,strong) RTAdView *ad;
```

3) Add the following lines to your view controller

```objective-c
    [self getScreenSize];
    self.ad= [[RTAdView alloc] initWithSize:RTAdPopUp];
    self.ad.frame = CGRectMake(0,0,_widthOfScreen,_heightOfScreen);
    
    if the view contains a navigation bar:
    [self.navigationController.view addSubview:self.ad];
    [self.navigationController.view bringSubviewToFront:self.ad];

    if the view contains a tab bar:
    [self.tabBarController.view addSubview:ad];
    [self.tabBarController.view bringSubviewToFront:ad];
    
    else
    [self.view addSubview:self.ad];
    [self.view bringSubviewToFront:self.ad];
    
    [self.ad prepareAd];
    [self.ad loadRequest];
```

---------------

###3. Native


1. Import the following file to your view controller

```objective-c
#import "RTAdView.h"
```
2. In the ViewController.m Interface 

```objective-c
@interface ViewController ()

@end
```
Add the following property

```objective-c
@property (nonatomic,strong) RTAdView *adView;
```

3. Add the following line to your view controller to show the ad


```objective-c
    self.adView = [[RTAdView alloc] initWithSize:RTAdNative1to1];
    self.adView.frame = CGRectMake(100,400,300,50);
    [self.view addSubview:self.adView];
    [self.view bringSubviewToFront:self.adView];
    [self.adView prepareAd];
    [self.adView loadRequest];
```

######Second line of code means that the ad will be on position (x=100,y=400) with size (width=300, height=50). 


######Important Notes: 

Note 1.Native ads can be placed anywhere INSIDE the screen. Placing the ad outside the boarder of the screen will result in deleteing the ad. (This also apply after device orientation)

Note 2.The Native must be initialized with respect to the following aspect ratios (4:1 , 3:2). 


*[Here](https://github.com/RedTroops/IOS-SDK/wiki/Adding-Native-ad-to-a-tableView) you can find the guide to add a native ad to a table view.

Note 3: Hidding the adView will result in deleting it. Instead use the following method

```objective-c
 [self.adView removeTheAd];
```
---------------

###Push Notifications

** You can find the guide for generating certificates and integrating them with RedTroops on this [link](https://github.com/RedTroops/IOS-SDK/wiki/iOS-Push-Notification-Integration)

1) Import the following file to your app delegate AppDelegate.m
```objective-c
    #import "RTNotificationManager.h"
```

2) In your app delegate (AppDelegate.m), find the method
```objective-c
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```

and add the following line of code
```objective-c
	application.applicationIconBadgeNumber = 0 ;

    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
      {
	//iOS 8
	[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
	(UIUserNotificationTypeSound | UIUserNotificationTypeAlert |UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
        
      } else {
 
 	//iOS < 8
	[application registerForRemoteNotificationTypes:
	(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert)];
      }
    
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
     {
        NSDictionary *payload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [[RTNotificationManager defaultManager]startProcessingNotificationPayload:payload];
     }
```
*Note: This code snippet handles notifications for iOS 8 and earlier versions. if you are targeting iOS 8 only, you can add the first part of the first if statement.


3) In your app delegate (AppDelegate.m), find the method
```objective-c
    -(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
```
and add the following line of code
```objective-c
    [[RTSessionManager defaultManager] registerDeviceToken:deviceToken];
```

4) In your app delegate (AppDelegate.m), find the method
```objective-c
    -(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
```
and add the following line of code
```objective-c
  [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
  
  [[RTNotificationManager defaultManager]startProcessingNotificationPayload:userInfo];
```

5) In your app delegate (AppDelegate.m), find the method
```objective-c
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
```
and add the following line of code

```objective-c
    NSLog(@"4:%@", error.localizedDescription);
```

*Remember: After creating you application on redtroop.com there 2 options (Development and Production).

Development is when your app is still under development and not on the AppStore yet. The certificates on Apple Dev Center are still the development ones.

Production is when your application in on the AppStore. The certificates on Apple Dev Center must be the production ones.


-----------

Commom Log Errors 

Click [here](https://github.com/RedTroops/IOS-SDK/wiki/Common-Log-Errors)

-------------

**If you need any help or for more information, please visit:**  <a href="http://docs.redtroops.com" class="btn">RedTroops Docs</a>
