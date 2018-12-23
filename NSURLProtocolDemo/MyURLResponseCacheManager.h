//
//  MyURLResponseCacheManager.h
//  NSURLProtocolDemo
//
//  Created by Junpeng Zheng on 2018/12/9.
//  Copyright © 2018 Junpeng Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyURLResponseCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyURLResponseCacheManager : NSObject

+ (instancetype)sharedInstance;

- (MyURLResponseCache *)queryCacheWithURL:(NSString *)url;
- (void)saveResponseCacheWithCache:(MyURLResponseCache *)cache forURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
