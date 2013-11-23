//
//  irainmeterAppDelegate.m
//  iRainmeter
//
//  Created by 祝嘉栋 on 13-11-23.
//  Copyright (c) 2013年 祝嘉栋. All rights reserved.
//

#import "irainmeterAppDelegate.h"

@implementation irainmeterAppDelegate

- (NSString *)getCityDefault
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * city;
    if ((city = [ud stringForKey:@"city"])) {
        return city;
    }
    else {
        [ud setObject:@"北京" forKey:@"city"];
        return @"北京";
    }
    return nil;
}

- (float)getTimerDefault
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    float timeInt;
    if ((timeInt = [ud doubleForKey:@"timeInterval"])) {
        return timeInt;
    }
    else {
        NSNumber * t = [NSNumber numberWithFloat:60.0];
        [ud setObject:t forKey:@"timeInterval"];
        return 60.0;
    }
    return 60.0;
}

- (void)refresh
{
    CityInfo * info = [[CityInfo alloc] initWithCity:[self getCityDefault]];
    NSLog(@"User Default: %@, %lf", [self getCityDefault], [self getTimerDefault]);
    [info getInfo:self];
}

- (void)startTimer
{
    timer = [NSTimer
             scheduledTimerWithTimeInterval:60.0
             target:self
             selector:@selector(refresh)
             userInfo:nil
             repeats:YES];
    [timer fire];
    [[NSRunLoop currentRunLoop] run];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.window orderOut:nil];
    
    NSStatusBar * bar = [NSStatusBar systemStatusBar];
    self.item = [bar statusItemWithLength:NSVariableStatusItemLength];
    [self.item setMenu:self.statusMenu];
    [self.item setHighlightMode:YES];
    [self.item setTitle:@"iRainmeter"];
    [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.item];
}

- (IBAction)settingButton:(id)sender {
    [self.window center];
    [[self window] makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
    [self.cityTextEdit setStringValue:[self getCityDefault]];
    [self.timeIntlTextEdit setStringValue:[NSString stringWithFormat:@"%lf", [self getTimerDefault]]];
}

- (void)didReceived:(NSString *)data
{
    NSLog(@"received");
    [self.item setTitle:data];
    NSLog(@"%@", [self.item title]);
    
}

- (IBAction)applyButton:(id)sender {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setDouble:[self.timeIntlTextEdit doubleValue] forKey:@"timeInterval"];
    [ud setObject:[self.cityTextEdit stringValue] forKey:@"city"];
    [self.window orderOut:nil];
    [timer fire];
}
@end
