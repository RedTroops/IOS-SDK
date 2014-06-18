//
//  BannersViewController.m
//  RedTroopsDemo
//
//  Created by Omar on 9/28/13.
//  Copyright (c) 2013 RedTroops. All rights reserved.
//

#import "BannersViewController.h"
#import "RedTroops.h"

@interface BannersViewController ()
{
    UIActivityIndicatorView *indicatorView;
}
@property(nonatomic, strong) NSArray *banners;

@end

@implementation BannersViewController

-(void) getBannerListRequestCompleted:(NSArray*)bannerList
{
    self.banners = bannerList;
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activity];
    activity.frame = self.view.bounds;
    activity.autoresizingMask = self.view.autoresizingMask;

    
    indicatorView = activity;
    [indicatorView startAnimating];

}

-(void)showBannerList
{
    // 4.2
    [RedTroops listBannerHTML5WithDelegate:self failure:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error description]
                                                       delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        
    }];
    
   

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.banners.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     [indicatorView stopAnimating];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
    }
    
  
    UIImage *img = [self getImageWithFileName:[NSString stringWithFormat:@"bannerImage%i.png",indexPath.row]];//[UIImage imageWithData:[NSData dataWithContentsOfURL:banner.imageURL] ];
    if (img == nil) {
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[_banners objectAtIndex:indexPath.row] imageURL] ]]];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = CGRectMake(0, 0,  [[UIScreen mainScreen] bounds].size.width, 60);
    [cell addSubview:imageView];
        return cell;
}

-(UIImage*)getImageWithFileName:(NSString*)imgFileName
{
    NSString* fileName = [NSString stringWithFormat:@"%@",imgFileName];
                          NSArray *arrayPaths =
                          NSSearchPathForDirectoriesInDomains(
                                                              NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES);
                          NSString *path = [arrayPaths objectAtIndex:0];
                          NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
                          NSLog(@"Image File Retrieve Path:%@",pdfFileName);
                          UIImage *image1=[UIImage imageWithContentsOfFile:pdfFileName];
    return  image1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RedTroopsBanner *banner = [self.banners objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:banner.URL];
}

@end
