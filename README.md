<p align="center">
<img src="http://www.redtroops.com/images/RedTroopsLogo.png" alt="RedTroops" width="150">
</p>


#RedTroops SDK 1.0 for IOS

Requirements: **IOS 5.0 +**

###Getting Started

RedTroops SDK 1.0 currently features:

**Push Notifications.**

**Send user spent time.**

**HTML5/Image Popups.**

**List of banners.**

**Setting Up RedTroops SDK 1.0 In Your Project**

Follow the steps below to get your RedTroops SDK 1.0 running:


1) Download the SDK from RedTroops' website.

2) Drag & Drop folder to your project.

3) Add following framework:

<ul>
<li>AdSupport.framework</li>
<li>SystemConfiguration.framework</li>
<li>QuartzCore.framework</li>
<li>CoreGraphics.framework</li>
</ul>


4) To allow Push Notification in your app, in AppDelegate.m, add following:

```objective-c
(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //notification
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if ( userInfo != nil ) {
        [self application:application didFinishLaunchingWithOptions:userInfo];
    }
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    application.applicationIconBadgeNumber = 0;
return YES;
}
```
5) To initialize SDK, in your AppDelegate.m class, add following lines in:
```objective-c
(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
// change here, just add Api_Key and Id here
    [RedTroops startSessionWithAppKey:@"<APP-SECRET-KEY>" AppId:@"<APP-ID>" andDeviceType:@"<DEVICE-TYPE>"];
    
      return YES;
}
```

6) Whenever you want to show an HTML5/Image popup, call:

```objective-c
[RedTroops showHTML5ImagePopup:self]
```

where parameter is of  (UIViewController*) representing current class
    
7) Whenever you want to show the more page, call:

```objective-c
[RedTroops showBannerListWithView:self]
```

where parameter is of  `(UIViewController*)` representing current class

8) To end your session, add the following to your last `AppDelegate.m`:

```objective-c
(void)applicationDidEnterBackground:(UIApplication *)application
{
    [RedTroops endSession];
}
```

This should only be called once after each app run when the user is no longer using the app.

9) Optional:  If your app in foreground, and you want to view `Push Notification`, than add following in `AppDelegate.m` and **Push Notification** can be viewed in `alertView`:

```objective-c
(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [RedTroops processRemoteNotification:userInfo];
}
```

**If you need any help or for more information, please visit:**  <a href="http://docs.redtroops.com" class="btn">RedTroops Docs</a>
