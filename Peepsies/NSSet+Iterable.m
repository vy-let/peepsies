//
//  NSSet+Iterable.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-29.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "NSSet+Iterable.h"
#import "NSArray+Iterable.h"

@implementation NSSet (Iterable)

- (NSSet *)map:(id (^)(id obj))block {
    NSMutableSet *new = [NSMutableSet set];
    for(id obj in self) {
        id newObj = block(obj);
        if (newObj)
            [new addObject: newObj];
    }
    return new;
}

- (NSSet *)select:(BOOL (^)(id obj))block {
    NSMutableSet *new = [NSMutableSet set];
    for(id obj in self)
        if(block(obj))
            [new addObject: obj];
    return new;
}

- (id)reduce:(id (^)(id memo, id obj))block {
    NSUInteger counterator = [self count];
    if (counterator < 2)
        return [self anyObject];
    
    id first = [self anyObject];
    __block id memo = first;
    for (id obj in self) {
        if (obj == first) continue;
        memo = block(memo, obj);
    }
    
    return memo;
}

- (id)fromSeed:(id)seed reduce:(id (^)(id memo, id obj))block {
    id memo = seed;
    for (id obj in self)
        memo = block(memo, obj);
    
    return memo;
}

- (NSArray *)shuffled {
    return [[self allObjects] shuffled];
}

@end
