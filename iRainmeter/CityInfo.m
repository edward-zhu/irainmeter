//
//  CityInfo.m
//  iRainmeter
//
//  Created by 祝嘉栋 on 13-11-23.
//  Copyright (c) 2013年 祝嘉栋. All rights reserved.
//

#import "CityInfo.h"

@implementation CityInfo
{
    NSInteger temp;
    NSInteger AQI;
}

@synthesize city;

- (id)initWithCity:(NSString *)theCity
{
    self = [super init];
    self.city = [theCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return self;
}

- (NSString *)getTemp
{
    NSError * error = nil;
    NSMutableDictionary * result;
    NSString * WEATHER_API_KEY = @"7e15d62a4c636733";
    NSString * WEATHER_URL =
        [NSString
         stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json",
         WEATHER_API_KEY,
         self.city];
    NSLog(@"%@", WEATHER_URL);
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:WEATHER_URL]];
    NSString * str = [NSString stringWithContentsOfURL:[NSURL URLWithString:WEATHER_URL] encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    NSLog(@"result : %ld", [str length]);
    result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"result : %@", result);
    
    return [NSString stringWithFormat:@"%@°C", result[@"current_observation"][@"temp_c"]];
}

- (NSString *)getAQI
{
    NSError * error = nil;
    NSString * AQI_API_KEY = @"psTHzAsyW9U57stvGNYP";
    NSString * AQI_URL = [NSString stringWithFormat:@"http://www.pm25.in/api/querys/pm2_5.json?city=%@&token=%@&avg=true&stations=no", self.city, AQI_API_KEY];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:AQI_URL]];
    NSArray * result;
    result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%@", result);
    
    return result[0][@"aqi"];
}

- (void)getInfo:(id<CityInfoDelegate>)delegate
{
    
    NSString * result = [NSString stringWithFormat:@"%@ | %@", [self getTemp], [self getAQI]];
    NSLog(@"returned %@", result);
    [delegate didReceived:result];
}


@end
