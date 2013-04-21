//
//  When.h
//  objc-promise
//
//  Created by Elmar Kretzer on 19.04.13.
//  Copyright (c) 2013 Elmar Kretzer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Deferred;
@class Promise;

typedef id(^DoneBlock)(id);
typedef id(^FailBlock)(id);

typedef void(^DeferredBlock)(Deferred*);

@interface When : NSObject

- (id)initWithDeferred:(Promise*) promise;
- (id)initWithBlock:(DeferredBlock) dfdBlock;

+ (When*)block:(DeferredBlock) dfdBlock;
- (When*(^)(DoneBlock,FailBlock))then;

@end
