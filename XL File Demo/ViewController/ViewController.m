//
//  ViewController.m
//  XLCreationExample
//
//  Created by Gagan on 13/10/14.
//  Copyright (c) 2014 Gagan. All rights reserved.
//

#import "ViewController.h"
#import "UIColor-Expanded.h"
#import "FileViewerController.h"
@interface ViewController ()

@end

@implementation ViewController

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
    floatForFile=0.0;
    arrayOfCreatedFiles=[NSMutableArray array];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *items=[[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil];
    for(NSString *strFileName in items)
    {
        if([strFileName isEqualToString:@".DS_Store"])
        {
            continue;
        }
        path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:strFileName];
        [arrayOfCreatedFiles addObject:path];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self CreateXLFile:^(BOOL success)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.myTableView reloadData];
             [self.myActivityIndicator stopAnimating];
         });
     }];
}

-(void)CreateXLFile:(MyCallBackMethod)completionBlock
{
    [self.myActivityIndicator startAnimating];
    RSworkBook *workBook=[[RSworkBook alloc]init];
    workBook.author=@"Gagan";
    workBook.date=[NSDate date];
    workBook.version=1.0;
    
    RSworkSheet *workShheet1=[[RSworkSheet alloc]initWithName:@"Sheet 1"];
    [workShheet1 setColumnWidth:180];
    RSworkSheetRow *row1=[[RSworkSheetRow alloc]initWithHeight:50];
    [row1 addCellString:@"Cell Data 1"];
    [row1 addCellString:@"Cell Data 2"];
    [row1 addCellString:@"Cell Data 3"];
    [row1 addCellString:@"Style Editing Work Book"];
    [row1 addCellNumber:floatForFile];
    NSDate *dateYesterday = [NSDate date];
    [dateYesterday dateByAddingTimeInterval:-86400];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *date = [dateFormater stringFromDate:dateYesterday];
    [row1 addCellString:date];
    [workShheet1 addWorkSheetRow:row1];
    floatForFile++;
    
    RSworkSheetRow *row2=[[RSworkSheetRow alloc]initWithHeight:20];
    [row2 addCellString:@"Cell Data 11"];
    [row2 addCellString:@"Cell Data 22"];
    [row2 addCellString:@"Cell Data 32"];
    [row2 addCellData:[NSDate date]];
    [row2 addCellNumber:floatForFile];
    [workShheet1 addWorkSheetRow:row2];
    floatForFile++;
    
    RSworkSheetRow *row3=[[RSworkSheetRow alloc]initWithHeight:30];
    [row3 addCellString:@"Cell Data 23"];
    [row3 addCellString:@"Cell Data 232"];
    [row3 addCellString:@"Cell Data 232"];
    NSDate *dateTomorrow = [NSDate date];
    [dateTomorrow dateByAddingTimeInterval:86400];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *dateString = [dateFormat stringFromDate:dateTomorrow];
    [row3 addCellString:dateString];
    [row1 addCellNumber:floatForFile];
    [workShheet1 addWorkSheetRow:row3];
    [workBook addWorkSheet:workShheet1];
    floatForFile++;
    NSString *pathDoc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES) objectAtIndex:0];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hhmmss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
   if( [workBook writeWithName:[NSString stringWithFormat:@"MyGeneratedXLSFile%@",[dateFormatter stringFromDate:now]] toPath:pathDoc])
   {
       [arrayOfCreatedFiles addObject:[pathDoc stringByAppendingPathComponent:[NSString stringWithFormat:@"MyGeneratedXLSFile%@.xls",[dateFormatter stringFromDate:now]]]];
       NSLog(@"XL  Created At Path: %@",pathDoc);
    }
   else{
       NSLog(@"FAILED");
   }
    completionBlock(YES);
}

#pragma mark-TabelView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfCreatedFiles.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=nil;
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        cell.textLabel.font=[UIFont systemFontOfSize:12];
        cell.textLabel.numberOfLines=0;
        cell.textLabel.text=[arrayOfCreatedFiles[indexPath.row] lastPathComponent];
        cell.imageView.image=[UIImage imageNamed:@"XL_Icon"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    QLPreviewController *previewController=[[QLPreviewController alloc]init];
    previewController.dataSource=self;
    filePathString=nil;
    filePathString=[[arrayOfCreatedFiles objectAtIndex:indexPath.row]copy];
    [self presentViewController:previewController animated:YES completion:nil];
     */
    NSURL *fileURL=[NSURL fileURLWithPath:[arrayOfCreatedFiles objectAtIndex:indexPath.row]];
    if(fileURL)
    {
        FileViewerController *object=[[FileViewerController alloc]init];
        object.fileURL=[fileURL copy];
        [self.navigationController pushViewController:object animated:YES];
        object=nil;
    }
}

#pragma mark-QLPreview Datasource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    if(filePathString)
    {
        NSURL *fileURL= [NSURL fileURLWithPath:filePathString];
        filePathString=nil;
        NSLog(@"fileURL is : %@",fileURL);
        return fileURL;
    }
    else
        return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
