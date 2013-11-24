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
        NSNumber * t = [NSNumber numberWithFloat:1800.0];
        [ud setObject:t forKey:@"timeInterval"];
        return 1800.0;
    }
    return 1800.0;
}

- (void)refresh
{
    [cityMenuItem setTitle:[NSString stringWithFormat:@"%@", [self getCityDefault]]];
    CityInfo * info = [[CityInfo alloc] initWithCity:[self getCityDefault]];
    NSLog(@"User Default: %@, %lf", [self getCityDefault], [self getTimerDefault]);
    [info getInfo:self];
    NSLog(@"Timer %@", [NSThread currentThread]);
    NSLog(@"%@", [info getOneDayForcast]);
}

- (void)startTimer
{
    timer = [NSTimer
             scheduledTimerWithTimeInterval:[self getTimerDefault]
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
    NSLog(@"主线程 %@", [NSThread currentThread]);
    NSStatusBar * bar = [NSStatusBar systemStatusBar];
    self.item = [bar statusItemWithLength:NSVariableStatusItemLength];
    [self.item setMenu:self.statusMenu];
    [self.item setHighlightMode:YES];
    [self.item setTitle:@"iRainmeter"];
    forcastMenuItem = [[NSMenuItem alloc] initWithTitle:@"预报获取中..." action:nil keyEquivalent:@""];
    cityMenuItem = [self.statusMenu insertItemWithTitle:@"城市" action:nil keyEquivalent:@"" atIndex:0];
    
    [self.statusMenu insertItem:forcastMenuItem atIndex:1];
    [self.statusMenu insertItem:[NSMenuItem separatorItem] atIndex:2];
    
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

- (void)didReceived:(NSString *)data withDailyForcast:(NSString *)dForcast
{
    NSLog(@"received");
    [self.item setTitle:data];
    [forcastMenuItem setTitle:dForcast];
    NSLog(@"%@", [self.item title]);
    
}

- (void)waitForReceive
{
    [self.item setTitle:@"正在获取天气.."];
}

- (IBAction)applyButton:(id)sender {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    if ([CityInfo isValidCity:[self.cityTextEdit stringValue]]) {
        [ud setObject:[self.cityTextEdit stringValue] forKey:@"city"];
        [ud setDouble:[self.timeIntlTextEdit doubleValue] forKey:@"timeInterval"];
        [self.window orderOut:nil];
        [timer fire];
    }
    else {
        NSAlert * alert = [NSAlert alertWithMessageText:@"无效城市" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"请确认城市名。"];
        [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
    
    
    
}
@end
