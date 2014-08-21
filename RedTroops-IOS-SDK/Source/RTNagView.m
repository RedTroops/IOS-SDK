//
//  RTNagView.m
//  RedTroopsDemo
//
//  Created by Omar on 8/20/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import "RTNagView.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

extern NSString *RED_TROOPS_BASE_URL,*RED_TROOPS_GET_ADS,*RED_TROOPS_SHOW_ADS;

@implementation RTNagView
{
    UIActivityIndicatorView *indicatorView;
    UIWebView *webView;
    
    NSString *imageCallbackUrl;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //if no internet, do nothing
    Reachability* reachability = [Reachability reachabilityWithHostName:@"developer.redtroops.com"];
    if (![reachability isReachable])
    {
       
        NSLog(@"No access to developer.redtroops.com at this moment.");
        [self removeFromSuperview];
        return;
    }
    
    webView = [[UIWebView alloc] init];
    [self addSubview:webView];

    NSString *bannUrl;
    if ([_popUpParam objectForKey:@"ad_id"])
    {
        bannUrl = [NSString stringWithFormat:@"%@%@?id=%@&user_id=%@&devie_type=%@&app_id=%@&api_key=%@&app_version=%@&size=%@&device_language=en", RED_TROOPS_BASE_URL,RED_TROOPS_GET_ADS, [_popUpParam objectForKey:@"ad_id"], [_popUpParam objectForKey:@"user_id"],[_popUpParam objectForKey:@"device_type"],[_popUpParam objectForKey:@"app_id"],[_popUpParam objectForKey:@"api_key"],[_popUpParam objectForKey:@"app_version"],[_popUpParam objectForKey:@"size"]];
    }
    else
    {
        bannUrl = [NSString stringWithFormat:@"%@%@?user_id=%@&devie_type=%@&app_id=%@&api_key=%@&app_version=%@&size=%@&device_language=en", RED_TROOPS_BASE_URL,RED_TROOPS_GET_ADS, [_popUpParam objectForKey:@"user_id"],[_popUpParam objectForKey:@"device_type"],[_popUpParam objectForKey:@"app_id"],[_popUpParam objectForKey:@"api_key"],[_popUpParam objectForKey:@"app_version"],[_popUpParam objectForKey:@"size"]];
    }
    
    NSString *urlUTF8 = [bannUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *bannerUrl = [NSURL URLWithString:urlUTF8];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:bannerUrl];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response = nil;
	NSError *error = nil;
	NSData * responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	urlRequest = nil;
    
    if (responseData != nil) {
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingMutableContainers
                              error:&error];
        
        //NSLog(@"HTML Popup Response: %@",json);

        if ((int)[[json valueForKey:@"success"] integerValue] == 1) {
            
            if ([json objectForKey:@"data"] && [[json objectForKey:@"data"] objectForKey:@"banner"]) {
                
                NSDictionary *bannerDic = [[json objectForKey:@"data"] objectForKey:@"banner"];
                
                if (![bannerDic isKindOfClass:[NSNull class]]) {
      
                    NSString *bannerType= [bannerDic objectForKey:@"type"];
                    NSString *bannerId = [bannerDic objectForKey:@"id"];
                                        
                    if ([bannerType isEqualToString:@"page"]) {
                        
                        NSString *bannUrl = [NSString stringWithFormat:@"%@%@?user_id=%@&devie_type=%@&app_id=%@&api_key=%@&app_version=%@&size=%@&id=%@",RED_TROOPS_BASE_URL,RED_TROOPS_SHOW_ADS,[_popUpParam objectForKey:@"user_id"],[_popUpParam objectForKey:@"device_type"],[_popUpParam objectForKey:@"app_id"],[_popUpParam objectForKey:@"api_key"],[_popUpParam objectForKey:@"app_version"],[_popUpParam objectForKey:@"size"],bannerId];
                        
                        bannerUrl = [NSURL URLWithString:bannUrl];
                    }
                    else if ([bannerType isEqualToString:@"banner"]) {
                        bannerUrl = [NSURL URLWithString:[bannerDic objectForKey:@"image_url"]];
                        UITapGestureRecognizer *webViewTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
                        webViewTapped.numberOfTapsRequired = 1;
                        webViewTapped.delegate = self;
                        [webView addGestureRecognizer:webViewTapped];
                        imageCallbackUrl = [bannerDic objectForKey:@"url"];
                    }
                    
                    
                    [webView loadRequest:[NSURLRequest requestWithURL:bannerUrl]];
                    
                    webView.delegate = self;
                    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                    CGRect rect = self.frame;
                    //rect = CGRectInset(rect, 8, 0);
                    
                    // rect.origin.y = 40;
                    // rect.size.height -= 45;
                    
                    webView.frame = rect;
                    
                    webView.allowsInlineMediaPlayback = YES;
                    webView.mediaPlaybackRequiresUserAction = NO;
                    webView.scrollView.bounces = NO;
                    
                    
                    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    [webView addSubview:activity];
                    activity.frame = webView.bounds;
                    activity.autoresizingMask = webView.autoresizingMask;
                    self.autoresizingMask = webView.autoresizingMask;
                    
                    indicatorView = activity;
                    webView.layer.cornerRadius = 8.0;
                    webView.clipsToBounds = YES;
                    [self createCloseButton];
                    
                    [self createCloseButton];
                    
                    self.hidden = NO;
                }else{
                    NSLog(@"No Banner");
                    [self removeFromSuperview];
                }
                
            }
            
            
        
        }else{
            NSLog(@"No Banner");            
            
        }
    }

    
   // self.hidden = NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"%@",imageCallbackUrl);
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageCallbackUrl]]];
}
-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    return string;
}
- (void)createCloseButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"X" forState:UIControlStateNormal];
    CGRect rect = CGRectMake(self.frame.size.width - 32, 20, 32, 32);
    button.frame = rect;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:button];
    [button addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeTapped
{
    [webView stopLoading];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[animation setSubtype:kCATransitionFade];
	[animation setDuration:.5];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.superview layer] addAnimation:animation forKey:@"mykey"];
    [self removeFromSuperview];
}

- (void)showInView:(UIView*)view
{
    //    [view addSubview:self];
    
    CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[animation setSubtype:kCATransitionFade];
	[animation setDuration:.5];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[view layer] addAnimation:animation forKey:@"mykey"];
    
    [view addSubview:self];
    self.hidden = YES;
    // CGRect rect = view.bounds;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
            {
                self.frame = CGRectMake(10, 10, 528, 280);
            } else{
                self.frame = CGRectMake(10, 10, 440, 280);
            }
        } else {
            self.frame = CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.height -40, [[UIScreen mainScreen] bounds].size.width-40);
        }
    } else {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
            {
                self.frame = CGRectMake(10, 10, 280, 528);
            } else{
                self.frame = CGRectMake(10, 10, 280, 440);
            }
        } else {
            self.frame = CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width -40, [[UIScreen mainScreen] bounds].size.height-40);
        }
    }
    
    // self.frame = rect;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ", (int)webView.frame.size.width]];
    [indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
{
    return YES;
}

- (void)dealloc
{
    
}

@end
