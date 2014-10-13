//
//  FileViewerController.h
//  XLCreationExample
//
//  Created by Gagan on 13/10/14.
//  Copyright (c) 2014 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FileViewerController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *myLocalWebView;
@property(strong,nonatomic) NSURL *fileURL;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadActivityIndicator;
@end
