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
    NSString * cityCode;
    NSString * AQI_API_KEY;
    NSString * WEATHER_API_KEY;
}

@synthesize city;

- (id)initWithCity:(NSString *)theCity
{
    self = [super init];
    self.city = [theCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    WEATHER_API_KEY = @"srRLeAmTroxPinDG8Aus3Ikl6tLGJd94";
    AQI_API_KEY = @"psTHzAsyW9U57stvGNYP";
    cityCode = [self getCityCode];
    
    return self;
}

- (NSString *)getCityCode
{
    NSError * error = nil;
    NSString * url = [NSString stringWithFormat:@"http://api.accuweather.com/locations/v1/cn/search?q=%@&apikey=%@&language=zh", self.city, WEATHER_API_KEY];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSArray * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        if ([result count]) {
            return result[0][@"Key"];
        }
    }
    else {
        NSLog(@"Error : %@", [error description]);
    }
    return nil;
}

- (NSString *)getTemp
{
    NSError * error = nil;
    NSArray * result;
    NSString * WEATHER_URL =
        [NSString
         stringWithFormat:@"http://api.accuweather.com/currentconditions/v1/%@.json?apikey=%@",
         cityCode,
         WEATHER_API_KEY];
    NSLog(@"%@", WEATHER_URL);
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:WEATHER_URL]];
    NSString * str = [NSString stringWithContentsOfURL:[NSURL URLWithString:WEATHER_URL] encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    NSLog(@"result : %ld", [str length]);
    result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"result : %@", result);
    
    return [NSString stringWithFormat:@"%@°C", result[0][@"Temperature"][@"Metric"][@"Value"]];
}

- (NSString *)getOneDayForcast
{
    NSError * error = nil;
    NSString * url = [NSString stringWithFormat:@"http://api.accuweather.com/forecasts/v1/daily/1day/%@?apikey=%@&metric=true&language=zh", cityCode, WEATHER_API_KEY];
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMapped error:&error];
    
    NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        NSDictionary * Temp = result[@"DailyForecasts"][0][@"Temperature"];
        NSString * overview = result[@"DailyForecasts"][0][@"Day"][@"IconPhrase"];
        NSString * str = [NSString
                          stringWithFormat:@"24h %@°C~%@°C %@",Temp[@"Minimum"][@"Value"],Temp[@"Maximum"][@"Value"], overview];
        
        return str;
    }
    
    return @"N/A";
}

- (NSString *)getAQI
{
    NSError * error = nil;
    
    NSString * AQI_URL = [NSString stringWithFormat:@"http://www.pm25.in/api/querys/pm2_5.json?city=%@&token=%@&avg=true&stations=no", self.city, AQI_API_KEY];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:AQI_URL]];
    NSObject * result;
    result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%@", result);
    if ([result class] == [NSDictionary class]) {
        return nil;
    }
    else
        return ((NSArray *)result)[0][@"aqi"];
}

- (void)getInfo:(id<CityInfoDelegate>)delegate
{
    [delegate waitForReceive];
    NSString * result = [NSString stringWithFormat:@"%@ | %@", [self getTemp], [self getAQI]];
    NSLog(@"returned %@", result);
    [delegate didReceived:result withDailyForcast:[self getOneDayForcast]];
}

+ (BOOL)isValidCity:(NSString *)city
{
    CityInfo * info = [[CityInfo alloc] initWithCity:city];
    if ([info getCityCode] && [info getAQI]) {
        return YES;
    }
    else
        return NO;
}


@end
