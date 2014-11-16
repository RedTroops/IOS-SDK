<p align="center">
<img src="http://redtroops.com/images/logo.png" alt="RedTroops">
</p>


#RedTroops SDK 2.0 for IOS

Requirements: **IOS 5.0 +**

###Getting Started

RedTroops SDK 2.0 currently features:

**Push Notifications.**

**Send user spent time.**

**HTML5/Image Popups.**



**Setting Up RedTroops SDK 2.0 In Your Project**

Follow the steps below to get your RedTroops SDK 2.0 running:


1) Download the SDK from RedTroops' website.

2) Drag & Drop downloaded files (RedTroops.a + include) to your project.

3) Add following framework:

<ul>
<li>SystemConfiguration.framework</li>
<li>QuartzCore.framework</li>
<li>CoreGraphics.framework</li>
<li>Security.framework</li>
<li>MobileCoreServices.framework</li>
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
    [[RTSessionManager defaultManager]startSessionWithAPIKey:@“Your API KEY”];
```
* Your API Key: You can find it in RedTroops administration panel.
  http://developer.dev.redtroops.com/app/index


3) In your app delegate (AppDelegate.m), find the method

```objective-c
    - (void)applicationWillTerminate:(UIApplication *)application
```

and add the following line of code
```objective-c
    [[RTSessionManager defaultManager] endSession];
 ```

---------------

###Showing Interstitial ad

1) Import the following file to your view controller
```objective-c
    #import "RTAdView.h"
```

2) Add the following line to your view controller
```objective-c
    RTAdView *adView = [[RTAdView alloc] initWithSize:RTAdPopUp];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    adView.frame = CGRectMake(0,0,screenWidth,screenHeight);
    adView.rootViewController = self;
    [adView loadRequest:[RTAdRequest request]];
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:adView];
```

---------------

###Push Notifications

** You can find the guide for generating certificates and integrating them with RedTroops on this [link](https://github.com/RedTroops/IOS-SDK/wiki/iOS-Push-Notification-Integration)

1) Import the following file to your app delegate AppDelegate.m
```objective-c
    #import “RTNotificationManager.h"
```

2) In your app delegate (AppDelegate.m), find the method
```objective-c
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```

and add the following line of code
```objective-c
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
    [[RTNotificationManager defaultManager]startProcessingNotificationPayload:userInfo];
```

**If you need any help or for more information, please visit:**  <a href="http://docs.redtroops.com" class="btn">RedTroops Docs</a>
