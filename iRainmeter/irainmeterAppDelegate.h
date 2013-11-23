//
//  irainmeterAppDelegate.h
//  iRainmeter
//
//  Created by 祝嘉栋 on 13-11-23.
//  Copyright (c) 2013年 祝嘉栋. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CityInfo.h"

@interface irainmeterAppDelegate : NSObject <NSApplicationDelegate, CityInfoDelegate>
{
    NSTimer * timer;
}

@property (assign) IBOutlet NSWindow *window;
@property NSStatusItem *item;
@property (weak) IBOutlet NSTextField *cityTextEdit;
@property (weak) IBOutlet NSTextField *timeIntlTextEdit;
- (IBAction)applyButton:(id)sender;

@property (weak) IBOutlet NSMenu *statusMenu;
- (IBAction)settingButton:(id)sender;
@end
