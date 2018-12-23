//
//  MyURLResponseCache.h
//  NSURLProtocolDemo
//
//  Created by Junpeng Zheng on 2018/12/9.
//  Copyright © 2018 Junpeng Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyURLResponseCache : NSObject <NSSecureCoding>

@property (nonatomic) NSURLResponse *response;
@property (nonatomic) NSData *cacheData;

@end

NS_ASSUME_NONNULL_END
