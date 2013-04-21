//
//  SCPromiseTests.m
//  SCPromiseTests
//
//  Created by Elmar Kretzer on 19.04.13.
//  Copyright (c) 2013 Elmar Kretzer. All rights reserved.
//

#import "WhenTests.h"
#import "Deferred.h"
#import "When.h"

@implementation WhenTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testWhenCallbacks
{
    __block id wrongCallbacks = [@[] mutableCopy];
    
    // map: callback position -> BOOL called
    __block id callbacks = [@{ @(1):@(NO), @(2):@(NO), @(3):@(NO), @(4):@(NO)} mutableCopy];
    
    // mark callback at position as done
    void (^done)(int) = ^(int position){
        NSLog(@"Callback at position: %u is done", position);
        callbacks[@(position)] = @(YES);
    };
    
    void (^wrong)(int) = ^(int position){
        NSLog(@"Wrong Callback at position: %u is done", position);
        [wrongCallbacks addObject:@(position)];
    };
    
    // check all callbacks for done
    BOOL (^allCallbacksDone)() = ^{
        __block BOOL allDone = YES;
        [callbacks enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if(![obj boolValue]){
                allDone = NO;
            }
        }];
        return allDone;
    };
    
    // execute with delay of seconds the block
    void (^doDelayed)(double, void(^)()) = ^(double seconds, void(^block)(void)){
        double delayInSeconds = seconds;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            block();
        });
    };
    
    
    // Initital When
    [When block:^(Deferred *dfd) {
        doDelayed(2, ^{
            [dfd resolve:@"First"];
        });
    }]
    // first callback
    .then(^(id resolve){
            done(1);
            return @"first callback is done";
        },^id(id error){
            wrong(1);
            return nil;
    })
    // 2nd callback
    .then(^(id resolve){
            return [Deferred deferredWithBlock:^(Deferred *dfd) {
                doDelayed(3, ^{
                    done(2);
                    [dfd resolve:@"second callback is done"];
                });
            }];
        },^id(id error){
            wrong(2);
            return nil;
    })
    // 3rd callback
    .then(^id(id resolve){
            done(3);
            return nil;
        },^id(id error){
            wrong(3);
            return nil;
    });
    
    NSLog(@"Should log first");

    [When block:^(Deferred *dfd) {
         [dfd reject:[NSError errorWithDomain:@"fail" code:0 userInfo:nil]];
    }]
    .then(^id(id resolve){
            wrong(4);
            return nil;
        },^id(id error){
            done(4);
            return nil;
    });
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (allCallbacksDone() == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
    
    if (!allCallbacksDone() || [wrongCallbacks count] > 0)
    {
        STFail(@"something went wrong");
    }
}

@end
