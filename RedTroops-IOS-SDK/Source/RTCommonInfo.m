//
//  RTCommonInfo.m
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import "RTCommonInfo.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

#import <AdSupport/AdSupport.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

static NSString *redTroopsAppID;
static NSString *redTroopsAppKey;
static NSString *userID;
static NSString *redTroopsAdID;

static NSString *deviceType;
static NSDate *currentTime;
@implementation RTCommonInfo

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


// Get IP Address
+ (NSString *)getIPAddress {
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    
    return addr;
}

+ (NSString *)uniqueGlobalDeviceIdentifier
{
	// IMPORTANT: iOS 6.0 has a bug when advertisingIdentifier or identifierForVendor occasionally might be empty! We have to fallback to hashed mac address here.
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.1")) {
		// >= iOS6 return advertisingIdentifier or identifierForVendor
		if ([NSUUID class]) {
			
            /*
             REMOVED FOR APPLE WITH AdSupport.framework
             if ([ASIdentifierManager class]) {
				NSString *uuidString = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
				if (uuidString) {
					return uuidString;
				}
			}*/
			
			if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
				NSString *uuidString = [[UIDevice currentDevice].identifierForVendor UUIDString];
				if (uuidString) {
					return uuidString;
				}
			}
		}
	}
    
	// Fallback on macaddress
    NSString *macaddress = [self macaddress];
    NSString *uniqueDeviceIdentifier = [self stringFromMD5:macaddress];
    
    return uniqueDeviceIdentifier;
}

+ (NSString *)macaddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (NSString *)stringFromMD5: (NSString *)val
{    
    if(val == nil || [val length] == 0)
        return nil;
    
    const char *value = [val UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString*)appBundleId
{
    NSString *appBundleID = [[NSBundle mainBundle] bundleIdentifier];
    return appBundleID;
}

+ (NSString*)appDisplayName
{
    NSString *appDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return appDisplayName;
}

+ (NSString*)appVersion
{
    NSString *appDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return appDisplayName;
}

+ (NSString*)currentLocale
{
    NSString * appLocale = @"en";
    NSLocale * locale = (NSLocale *)CFBridgingRelease(CFLocaleCopyCurrent());
    NSString * localeId = [locale localeIdentifier];
    
    if([localeId length] > 2)
        localeId = [localeId stringByReplacingCharactersInRange:NSMakeRange(2, [localeId length]-2) withString:@""];
    
    appLocale = localeId;
    
    NSArray * languagesArr = (NSArray *) CFBridgingRelease(CFLocaleCopyPreferredLanguages());
    if([languagesArr count] > 0)
    {
        NSString * value = [languagesArr objectAtIndex:0];
        
        if([value length] > 2)
            value = [value stringByReplacingCharactersInRange:NSMakeRange(2, [value length]-2) withString:@""];
        
        appLocale = [value copy];
    }
    
    return appLocale;
}

+ (void)setRedTroopsAppID:(NSString*)appID
{
    redTroopsAppID = appID;
}
+ (NSString*)redTroopsAppID
{
    return redTroopsAppID;
}
+ (NSString*)redTroopsAdID
{
    return redTroopsAdID;
}
+ (void)setUserID:(NSString*)userId
{
    userID = userId;
}
+ (NSString*)userID
{
    return userID;
}

+ (void)setRedTroopsAppKey:(NSString*)appKey
{
    redTroopsAppKey = appKey;
}
+ (NSString*)redTroopsAppKey
{
    return redTroopsAppKey;
}

+ (NSString*)deviceToken
{
    
    //NSLog(@"deviceToken: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"RedTroopsDeviceToken"]);

    return [[NSUserDefaults standardUserDefaults] valueForKey:@"RedTroopsDeviceToken"];
}

+ (void)setDeviceToken:(NSString*)deviceToken
{
    
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken
                                             forKey:@"RedTroopsDeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void) setCurrentTime:(NSDate*)curTime
{
    currentTime = curTime;
}
+ (NSDate*)currentTime
{
    return currentTime;//[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
}

+ (NSString*)iOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+(void)setDeviceType:(NSString *)devType
{
    deviceType = devType;
}

+(NSString*)deviceType
{
    return deviceType;
}

+ (void)fillCustomInfo:(NSMutableDictionary*)dictionary
{
    if ([RTCommonInfo deviceToken])
    {
        [dictionary setObject:[RTCommonInfo deviceToken] forKey:@"device_token"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if([defaults objectForKey:[RTCommonInfo deviceToken]]) {
            [RTCommonInfo setUserID:[defaults objectForKey:[RTCommonInfo deviceToken]]];
        }
    }
    
    if ([RTCommonInfo userID]) {
        [dictionary setObject:[RTCommonInfo userID] forKey:@"user_id"];
    }
    [dictionary setObject:[RTCommonInfo deviceType] forKey:@"device_type"]; // added by me
    [dictionary setObject:[RTCommonInfo redTroopsAppKey] forKey:@"api_key"];
    
    [dictionary setObject:[RTCommonInfo redTroopsAppID] forKey:@"ad_id"];

    [dictionary setObject:[RTCommonInfo redTroopsAppID] forKey:@"app_id"];
    [dictionary setObject:[RTCommonInfo iOSVersion] forKey:@"iOSVersion"];
    [dictionary setObject:[RTCommonInfo appDisplayName] forKey:@"dispName"];
    [dictionary setObject:[RTCommonInfo appVersion] forKey:@"app_version"];
    [dictionary setObject:[RTCommonInfo getIPAddress] forKey:@"ip_address"];

    [dictionary setObject:[RTCommonInfo uniqueGlobalDeviceIdentifier] forKey:@"uniqueId"];
    [dictionary setObject:[RTCommonInfo uniqueGlobalDeviceIdentifier] forKey:@"uid"]; // added by me
    [dictionary setObject:[RTCommonInfo getBannerSize] forKey:@"size"];
}

+(NSString*) getBannerSize
{
    NSString *bannerSize = @"477x170";
    //900x320 639x227 477x170 315x112 1120x300 1534x411 767x206
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad retina running iOS 3.2 or later.
        if ([[UIScreen mainScreen] bounds].size.height == 1024.0f)
        {
            bannerSize = @"900x320";
        }
        else if (( [ [ UIScreen mainScreen ] bounds ].size.height == 512 )) // iPad Mini, and non-retina iPad's
        {
            bannerSize = @"639x227";
        }
    }
    else
    {
        // The device is an iPhone5 or iPod touch.
        if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
        {
            bannerSize = @"477x170";
        }
        else if(( [ [ UIScreen mainScreen ] bounds ].size.height == 480 ))// The device is an iPhone4 or iPod touch.
        {
            bannerSize = @"315x112";
        }
    }
    
    return bannerSize;
}
@end
