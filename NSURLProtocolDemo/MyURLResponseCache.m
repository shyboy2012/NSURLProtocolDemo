//
//  MyURLResponseCache.m
//  NSURLProtocolDemo
//
//  Created by Junpeng Zheng on 2018/12/9.
//  Copyright © 2018 Junpeng Zheng. All rights reserved.
//

#import "MyURLResponseCache.h"

@implementation MyURLResponseCache

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    MyURLResponseCache *cache = [MyURLResponseCache new];
    cache.response = [aDecoder decodeObjectForKey:@"response"];
    cache.cacheData = [aDecoder decodeObjectForKey:@"cacheData"];
    return cache;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.response forKey:@"response"];
    [aCoder encodeObject:self.cacheData forKey:@"cacheData"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}
@end
