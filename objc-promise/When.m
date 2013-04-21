//
//  When.h
//  objc-promise
//
//  Created by Elmar Kretzer on 19.04.13.
//  Copyright (c) 2013 Elmar Kretzer. All rights reserved.
//

#import "When.h"
#import "Deferred.h"
#import "Promise.h"

@implementation When{
   Promise* _promise;
}

- (id)initWithDeferred:(Promise*) promise
{
    self = [super init];
    if(self){
        _promise = promise;
    }
    return self;
}

- (id)initWithBlock:(void(^)(Deferred *dfd)) dfdBlock;
{
    Deferred *dfd = [[Deferred alloc] initWithBlock:dfdBlock];
    return [self initWithDeferred:dfd];
}

+ (When*)block:(void(^)(Deferred *dfd)) dfdBlock
{
    return [[When alloc] initWithBlock:dfdBlock];
}

- (When*(^)(DoneBlock, FailBlock))then
{
    return ^When *(DoneBlock resolveBlock, FailBlock errorBlock){
        
        Deferred *deferred = [Deferred new];
        
        void (^resolveWithDeferred)(Deferred*) = ^(Deferred *dfd){
            [dfd when:^(id resolvedResult) {
                [deferred resolve:resolvedResult];
            } failed:^(NSError *resolvedError) {
                [deferred reject:resolvedError];
            }];
        };
        
        [_promise when:^(id result) {
            id resolved = resolveBlock(result);
            BOOL isDeferred = [resolved respondsToSelector:@selector(resolve:)];
            if(isDeferred){
                resolveWithDeferred(resolved);
            } else {
                [deferred resolve:resolved];    
            }
        } failed:^(NSError *error) {
            id resolved = errorBlock(error);
            BOOL isDeferred = [resolved respondsToSelector:@selector(resolve:)];
            if(isDeferred){
                resolveWithDeferred(resolved);
            } else {
                [deferred reject:resolved];
            }
        }];
        
        return [[When alloc] initWithDeferred:deferred];
    };
}

@end
