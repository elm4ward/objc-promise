//
//  Deferred.h
//  objc-promise
//
//  Created by Michael Roberts on 2012-10-12.
//  Copyright (c) 2012 Mike Roberts. All rights reserved.
//

#import "Promise.h"

@interface Deferred : Promise

+ (Deferred *)deferred;
+ (id)deferredWithBlock:(void(^)(Deferred* dfd))block;

- (id)initWithBlock:(void(^)(Deferred* dfd))block;
- (Promise *)promise;
- (Promise *)resolve:(id)result;
- (Promise *)reject:(NSError *)reason;

@end
