
//
//  RTRequestManager.m
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import "RTRequestManager.h"
#import "RTCommonInfo.h"
#import "Reachability.h"
#define TIMEOUT 30

extern NSString *RED_TROOPS_BASE_URL,*RED_TROOPS_START_UP,*RED_TROOPS_END_SESSION,*RED_TROOPS_GET_ADS_LIST;

@implementation RTRequestManager

+ (RTRequestManager *) sharedManager
{
	static RTRequestManager *instance = nil;
    
	if (!instance) {
		instance = [[RTRequestManager alloc] init];
	}
    
	return instance;
}


- (BOOL) sendRequest:(NSDictionary *)params
            response:(NSString**)retResponse
               error:(NSError **)retError
      andRequestType:(RequestSendType)rType;

{
    //if no internet, do nothing
    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.developer.redtroops.com"];
    if (![reachability isReachable])
    {
        
        NSLog(@"Could not connect to RedTroops Servers.");
        return false;
    }
    // 1.5     // 2.4
    if (rType == kRequestForSendingDeviceToken) {
        
        return [self sendRequest:params ForPushNotificationAndError:retError response:retResponse];
        
    } else if (rType == kRequestForEndSession) {
        
        return [self sendRequest:params ForEndUserSessionAndError:retError response:retResponse];
        
    } else if (rType == kRequestForBannerLsit) {
        return [self sendRequest:params ForBannerListAndError:retError response:retResponse];
    }
    return true;
}



- (BOOL) sendRequest:(NSDictionary *)params
    ForPushNotificationAndError:(NSError **)retError
                        response:(NSString **)retResponse
{
        
    // 1.6
    NSString *post;
    
    post = [NSString stringWithFormat:@"device_type=%@&app_id=%@&api_key=%@&uid=%@&device_token=%@&app_version=%@&os_version=%@&device_language=%@",[params objectForKey:@"device_type"],[params objectForKey:@"app_id"],[params objectForKey:@"api_key"],[params objectForKey:@"uid"],[params objectForKey:@"device_token"],[params objectForKey:@"app_version"],[params objectForKey:@"iOSVersion"],@"en"];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%zd", [postData length]];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", RED_TROOPS_BASE_URL,RED_TROOPS_START_UP]]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setTimeoutInterval:TIMEOUT];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
	//Send data to server
	NSHTTPURLResponse *response = nil;
	NSError *error = nil;
	NSData * responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	urlRequest = nil;
    
	if(retError)
		*retError = error;
	
    if (responseData == nil) {
        NSLog(@"Response of Push Notification: Response is nil");
        return false;
    }
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"RedTroops Server Response:%@",responseString);
    
    if (retResponse != NULL) {
        *retResponse = responseString;
    }
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:NSJSONReadingMutableContainers
                          error:&error];
    if ((int)[[json valueForKey:@"success"] integerValue] == 1) {
        
        if ([json objectForKey:@"data"]) {
            
            NSDictionary *dic = [json objectForKey:@"data"];
            if (dic && [dic objectForKey:@"id"]) {
                // Store the data
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[dic objectForKey:@"id"] forKey:[params objectForKey:@"device_token"]];
                 [defaults synchronize];
            }
        }
    }
    

	return YES;
}

- (BOOL) sendRequest:(NSDictionary *)params
ForEndUserSessionAndError:(NSError **)retError
            response:(NSString **)retResponse
{
    
     // 2.5
    NSDate *curTime = [NSDate date];
    NSDate *prevStoreCurTime = [RTCommonInfo currentTime];
    NSString *timeSpent =[NSString stringWithFormat:@"%f", [curTime timeIntervalSinceDate:prevStoreCurTime]];
         
    NSString *post;
    post = [NSString stringWithFormat:@"app_id=%@&api_key=%@&user_id=%@&duration=%i&app_version=%@",[params objectForKey:@"app_id"],[params objectForKey:@"api_key"],[params objectForKey:@"user_id"],[timeSpent integerValue],[params objectForKey:@"app_version"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%zd", [postData length]];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", RED_TROOPS_BASE_URL,RED_TROOPS_END_SESSION]]];
    [urlRequest setHTTPMethod:@"POST"];
     [urlRequest setTimeoutInterval:TIMEOUT];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
	//Send data to server
	NSHTTPURLResponse *response = nil;
	NSError *error = nil;
	NSData * responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	urlRequest = nil;
	
	if(retError)
		*retError = error;
	
    if (responseData == nil) {
        NSLog(@"Response of ForEndUserSessionAndError: Response is nil");
        return false;
    }
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
     //NSLog(@"End User Response:%@",responseString);
    if (retResponse != NULL) {
        *retResponse = responseString;
    }
     //NSLog(@"Response of End Session:%@ ",responseString);

	return YES;
}

- (BOOL) sendRequest:(NSDictionary *)params
ForBannerListAndError:(NSError **)retError
            response:(NSString **)retResponse
{
    
    NSString *bannUrl = [NSString stringWithFormat:@"%@%@?user_id=%@&devie_type=%@&app_id=%@&api_key=%@&app_version=%@&size=%@&device_language=en",RED_TROOPS_BASE_URL,RED_TROOPS_GET_ADS_LIST,[params objectForKey:@"user_id"],[params objectForKey:@"device_type"],[params objectForKey:@"app_id"],[params objectForKey:@"api_key"],[params objectForKey:@"app_version"],[params objectForKey:@"size"]];

    
    NSString *urlUTF8 = [bannUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *bannerUrl = [NSURL URLWithString:urlUTF8];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:bannerUrl];
     [urlRequest setTimeoutInterval:TIMEOUT];
    [urlRequest setHTTPMethod:@"GET"];
    
	//Send data to server
	NSHTTPURLResponse *response = nil;
	NSError *error = nil;
	NSData * responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	urlRequest = nil;
	
    if (responseData == nil) {
        NSLog(@"Response of ForBannerListAndError: Response is nil");
        return false;
    }
	if(retError)
		*retError = error;
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
     NSLog(@"BannerList Response:%@",responseString);
    if (retResponse != NULL) {
        *retResponse = responseString;
    }
    
    //NSLog(@"Response of BannerList:%@ ",responseString);

	return YES;
}

@end
