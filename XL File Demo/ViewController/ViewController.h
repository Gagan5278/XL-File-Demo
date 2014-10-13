//
//  ViewController.h
//  XLCreationExample
//
//  Created by Gagan on 13/10/14.
//  Copyright (c) 2014 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "RSworkBook.h"
typedef void (^MyCallBackMethod) (BOOL);
@interface ViewController : UIViewController<QLPreviewControllerDataSource>
{
    float floatForFile;
    NSMutableArray *arrayOfCreatedFiles;
    NSString *filePathString;
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *myActivityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
