/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  MainViewController.h
//  BSG
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController () <UIWebViewDelegate> {
    NSUserDefaults *defaults;
}
@end

@implementation MainViewController


- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.

    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    _wv.delegate = self;
    
    _wv.layer.borderColor = [UIColor redColor].CGColor;
    _wv.layer.borderWidth = 1.0f;
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"messagechat" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_wv loadHTMLString:htmlString baseURL:nil];*/
}

- (void)pushStart{
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetch) userInfo:nil repeats:YES];
}

//#######################################################################################
- (void)objcFuncFromJS{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"Are you sure you want to delete this.  This action cannot be undone" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
    [alert show];
    //[self webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([[[request URL] absoluteString] hasPrefix:@"hybrid:"]) {
        
        NSString *requestString = [[request URL] absoluteString];
        NSArray *components = [requestString componentsSeparatedByString:@"://"];
        NSString *functionName = [components objectAtIndex:1];
        
        [self performSelector:NSSelectorFromString(functionName)];
        
        /*webView.delegate = self;
        
        webView.layer.borderColor = [UIColor redColor].CGColor;
        webView.layer.borderWidth = 1.0f;
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
        
        [webView stringByEvaluatingJavaScriptFromString:@"jsFuncFromObjc()"];*/
        
        return NO;
    }
    else if([[[request URL] absoluteString] hasPrefix:@"hybrid1:"])
    {
        
        
        webView.delegate = self;
        
        webView.layer.borderColor = [UIColor redColor].CGColor;
        webView.layer.borderWidth = 1.0f;
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"www//startup" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
        
        [webView stringByEvaluatingJavaScriptFromString:@"b()"];
    }
    else{
        return YES;
    }
}
//#######################################################################################

- (IBAction)start:(id)sender {
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(fetch) userInfo:nil repeats:YES];
    
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~fetch Data from Webserver~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)fetch{
    // NSURLRequest 객체 생성
    // 통신을 Request(요청)하는 객체를 만든다
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    
    // POST 내용을 작성
    NSString *post = [NSString stringWithFormat:@""];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    // Request 객체에 들어갈 내용들 설정
    [request setURL:[NSURL URLWithString:@"http://google.com"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:30.0];
    
    // 커넥션 에러를 다룰 객체를 생성
    NSError *error = nil;
    // NSURLConnection 객체를 이용해 동기적으로 보냄 (Response객체는 사용하지 않음)
    // 돌아온 값은 NSData형으로 받는다
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:&error];
    if(data == NULL){
        // 통신 실패 !
        //NSLog(@"통신 실패 ! : %@",[error LocalizedDescription]);
        NSLog(@"Connection could not be made");
    }
    else{
        // 통신 성공
        // 받아온 정보가 스트링인 경우
        NSString *response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [self notification];
        NSLog(@"Return String : %@",response);
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Notification Show~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)notification{
    [defaults setBool:YES forKey:@"notificationIsActive"];
    [defaults synchronize];
    //self.message.text = @"Notification Started";
    
    NSTimeInterval interval;
    interval = 1;
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    localNotification.alertTitle = @"aaaaaaaaaa";
    localNotification.alertBody = @"Good morning? I am aladin.";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSCalendarUnitDay;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

- (IBAction)stop:(id)sender {
    //self.message.text = @"Notifications Stopped";
    [defaults setBool:NO forKey:@"notificationIsActive"];
    [defaults synchronize];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/* Comment out the block below to over-ride */

/*
- (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}
*/

@end

@implementation MainCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
   in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation MainCommandQueue

/* To override, uncomment the line in the init function(s)
   in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end
