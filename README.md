<p align="center">
<img src="http://redtroops.com/images/logo_large.png" alt="RedTroops" width="150px">
</p>


#RedTroops SDK 3.2.1 for IOS

Requirements: **IOS 6.0 +**

###Getting Started

RedTroops SDK 3.2.1 currently features:

**Push Notifications.**

**Send user spent time.**

**4 types of (HTML5/Image/Video/Audio) ads.**


---------------
######[Cocos2d](https://github.com/RedTroops/IOS-SDK/wiki/Cocos2d---Cocos2d-x-Documentation), [Cocos2d-x](https://github.com/RedTroops/IOS-SDK/wiki/Cocos2d---Cocos2d-x-Documentation), and [Unity](https://github.com/RedTroops/Unity-SDK) documentation are available


---------------



**Setting Up RedTroops SDK 3.2.1 In Your Project**

Follow the steps below to get your RedTroops SDK 3.2.1 running:


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

#####4. Audio 

#####5. Video 



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
    [self.topBanner showAd];


    
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
    [self.bottomBanner showAd];

```

##### Check if ad is available 

Ad can now be check is available before adding it

```objective-c

	self.bottomBanner = [[RTAdView alloc] initWithSize:RTAdBannerBottom];
	int check = [self.bottomBanner checkAdAvailability];
	if(check == 1)
	{
		//add is available
	}
	else
	{
		//add is not available
	}
	
```


###### Important notes

Note 1: Banner’s size and position are fixed, changing any will result in removing them from the view.

Note 2: "showAd" method could be called anytime after "loadRequest" even in another method.

Note 3: Hidding the adView will result in deleting it. Instead use the following method.

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

3) Add the following lines to prepare the Ad

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
3) Add the following lines to show the Ad

```objective-c

       [self.ad showAd];

```

##### Check if ad is available 

Ad can now be check is available before adding it

```objective-c

	self.ad = [[RTAdView alloc] initWithSize:RTAdPopUp];
	int check = [self.ad checkAdAvailability];
	if(check == 1)
	{
		//add is available
	}
	else
	{
		//add is not available
	}
	
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
    self.adView = [[RTAdView alloc] initWithSize:RTAdNative];
    self.adView.frame = CGRectMake(100,400,300,50);
    [self.view addSubview:self.adView];
    [self.view bringSubviewToFront:self.adView];
    [self.adView prepareAd];
    [self.adView loadRequest];
    [self.adView showAd];

```

##### Check if ad is available 

Ad can now be check is available before adding it

```objective-c

	self.adView = [[RTAdView alloc] initWithSize:RTAdNative];
	int check = [self.adView checkAdAvailability];
	if(check == 1)
	{
		//add is available
	}
	else
	{
		//add is not available
	}
	
```


######Second line of code means that the ad will be on position (x=100,y=400) with size (width=300, height=50). 


######Important Notes: 

Note 1: Native ads can be placed anywhere INSIDE the screen. Placing the ad outside the boarder of the screen will result in deleteing the ad. (This also apply after device orientation)


*[Here](https://github.com/RedTroops/IOS-SDK/wiki/Adding-Native-ad-to-a-tableView) you can find the guide to add a native ad to a table view.

Note 2: Hidding the adView will result in deleting it. Instead use the following method

```objective-c
 [self.adView removeTheAd];
```
---------------

###4. Audio Ad

The Audio Ad will play an audio file.

1. Import the following file to your view controller

```objective-c
#import "RTAudio.h"
#import <AVFoundation/AVFoundation.h>
```

2. add this object to the interface

```objective-c
@property (nonatomic, strong) AVPlayerItem *playerItem;
```

3. add this to play an audio ad

```objective-c

    self.playerItem = [[AVPlayerItem alloc]init];
    RTAudio *player = [[RTAudio alloc]initWithPlayerItem:self.playerItem];
    [player playRTAudioAd];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RedTroopsAudioAdFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    

```

and this method is called after the audio ad finished playing

```objective-c

-(void)RedTroopsAudioAdFinished:(NSNotification *) notification {
    
    NSLog(@"Finished");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
}

```

##### Check if audio is available 

Ad can now be check if available before adding it

```objective-c

	int check = [player checkAudioAvailability];

	if(check == 1)
	{
		//add is available
	}
	else
	{
		//add is not available
	}
	
```


---------------

###5. Video Ad


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
    #import "RTVideo.h"
```

2) In the ViewController.m Interface 

```objective-c
@interface ViewController ()

@end
```
Add the following property

```objective-c
@property (nonatomic,strong) RTVideo *videoAd;;
```

3) Add the following lines to  get video ad

```objective-c

    [self getScreenSize];
    self.videoAd = [[RTVideo alloc]initWithSize:RTAdVideo];
    self.videoAd .frame = CGRectMake(0, 0, _widthOfScreen*2, _heightOfScreen*2);
    [self.view addSubview:self.videoAd ];
    
    [self.videoAd  prepareAd];
    [self.videoAd  playAd];
    [self.videoAd  addObserver:self forKeyPath:@"frame" options:0 context:NULL];

    
```


4) Add this method, which will be called after closing the ad.

```objective-c

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"Video ad closed");
    [self.videoAd  removeObserver:self forKeyPath:@"frame"];
}

```


##### Check if Video is available 

Ad can now be check if available before adding it

```objective-c

	int check = [self.videoAd checkVideoAvailability];

	if(check == 1)
	{
		//add is available
	}
	else
	{
		//add is not available
	}
	
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
