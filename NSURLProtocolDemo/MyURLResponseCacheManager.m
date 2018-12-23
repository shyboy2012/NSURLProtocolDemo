//
//  MyURLResponseCacheManager.m
//  NSURLProtocolDemo
//
//  Created by Junpeng Zheng on 2018/12/9.
//  Copyright © 2018 Junpeng Zheng. All rights reserved.
//

#import "MyURLResponseCacheManager.h"

@implementation MyURLResponseCacheManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MyURLResponseCacheManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [MyURLResponseCacheManager new];
    });
    return manager;
}

- (MyURLResponseCache *)queryCacheWithURL:(NSString *)url {
    MyURLResponseCache *cache = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:url];
    if (data) {
        cache = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return cache;
}

- (void)saveResponseCacheWithCache:(MyURLResponseCache *)cache forURL:(NSString *)url {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cache];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:url];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
