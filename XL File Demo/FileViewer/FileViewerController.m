//
//  FileViewerController.m
//  XLCreationExample
//
//  Created by Gagan on 13/10/14.
//  Copyright (c) 2014 Gagan. All rights reserved.
//

#import "FileViewerController.h"

@interface FileViewerController ()

@end

@implementation FileViewerController
@synthesize fileURL;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myLocalWebView.delegate=self;
    [self.loadActivityIndicator startAnimating];
    [self.myLocalWebView loadRequest:[NSURLRequest requestWithURL:self.fileURL]];
}

#pragma mark-webView Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadActivityIndicator stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.loadActivityIndicator stopAnimating];
    NSLog(@"Error is : %@",error.localizedDescription);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
