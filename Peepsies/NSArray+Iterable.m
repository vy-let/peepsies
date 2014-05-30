//
//  NSArray+Iterable.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-28.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "NSArray+Iterable.h"

@implementation NSArray (Iterable)

// Taken directly from Mike Ash
// https://www.mikeash.com/pyblog/friday-qa-2009-08-14-practical-blocks.html
// and then modified a bit to filter out nil.

- (NSArray *)map:(id (^)(id obj))block {
    NSMutableArray *new = [NSMutableArray array];
    for(id obj in self) {
        id newObj = block(obj);
        if (newObj)
            [new addObject: newObj];
    }
    return new;
}

- (NSArray *)select:(BOOL (^)(id obj))block {
    NSMutableArray *new = [NSMutableArray array];
    for(id obj in self)
        if(block(obj))
            [new addObject: obj];
    return new;
}

- (id)reduce:(id (^)(id memo, id obj))block {
    NSUInteger counterator = [self count];
    if (counterator < 2)
        return [self firstObject];
    
    __block id memo = [self firstObject];
    [self enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, counterator-1)] options:0 usingBlock:^(id obj, NSUInteger idex, BOOL *stop) {
        memo = block(memo, obj);
    }];
    
    return memo;
}

- (id)fromSeed:(id)seed reduce:(id (^)(id memo, id obj))block {
    id memo = seed;
    for (id obj in self)
        memo = block(memo, obj);
    
    return memo;
}





- (NSArray *)shuffled {
    NSMutableArray *intermediate = [self mutableCopy];
    
    // From http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray :
    NSUInteger count = [intermediate count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSUInteger nElements = count - i;
        NSInteger n = arc4random_uniform((u_int32_t)nElements) + i;
        [intermediate exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return intermediate;
}



@end
