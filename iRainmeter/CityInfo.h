//
//  CityInfo.h
//  iRainmeter
//
//  Created by 祝嘉栋 on 13-11-23.
//  Copyright (c) 2013年 祝嘉栋. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CityInfoDelegate;

@interface CityInfo : NSObject

@property NSString * city;
@property id<CityInfoDelegate> cityInfoDelegate;

- (id)initWithCity:(NSString *)city;
- (void)getInfo:(id<CityInfoDelegate>)delegate;


@end

@protocol CityInfoDelegate <NSObject>

- (void)didReceived:(NSString *)data;

@end
