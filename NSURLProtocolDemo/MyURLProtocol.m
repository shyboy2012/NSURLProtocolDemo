//
//  MyURLProtocol.m
//  NSURLProtocolDemo
//
//  Created by Junpeng Zheng on 2018/12/9.
//  Copyright © 2018 Junpeng Zheng. All rights reserved.
//

#import "MyURLProtocol.h"
#import "MyURLResponseCacheManager.h"

static NSString * const MYURLPROTOCOLREQUESTKEY = @"MYURLPROTOCOLREQUESTKEY";

@interface MyURLProtocol() <NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) MyURLResponseCache *tempCache;

@end

@implementation MyURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    static NSUInteger requestCount = 0;
    NSLog(@"Request #%lu: URL = %@", requestCount++, request.URL.absoluteString);
    BOOL isExistRequest = [[NSURLProtocol propertyForKey:MYURLPROTOCOLREQUESTKEY inRequest:request] boolValue];
    return !isExistRequest;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    MyURLResponseCache *cache = [[MyURLResponseCacheManager sharedInstance] queryCacheWithURL:[self.request.URL absoluteString]];
    if (cache) {
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:cache.response.MIMEType expectedContentLength:cache.cacheData.length textEncodingName:cache.response.textEncodingName];
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:cache.cacheData];
        [self.client URLProtocolDidFinishLoading:self];
    } else {
        NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:self.request.URL];
        [mutableRequest setValue:[self.request valueForHTTPHeaderField:@"User-Agent"] forHTTPHeaderField:@"User-Agent"];
        [NSURLProtocol setProperty:@(YES) forKey:MYURLPROTOCOLREQUESTKEY inRequest:mutableRequest];
        self.connection = [[NSURLConnection alloc] initWithRequest:[mutableRequest copy] delegate:self];
        static NSUInteger requestCount = 0;
        NSLog(@"Request startLoading #%lu: URL = %@", requestCount++, self.request.URL.absoluteString);
    }
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.tempCache = [MyURLResponseCache new];
    self.tempCache.response = response;
    self.tempCache.cacheData = [NSData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    NSMutableData *mutableData = [self.tempCache.cacheData mutableCopy];
    [mutableData appendData:data];
    self.tempCache.cacheData = [mutableData copy];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
    [[MyURLResponseCacheManager sharedInstance] saveResponseCacheWithCache:self.tempCache forURL:[self.request.URL absoluteString]];
}
@end
