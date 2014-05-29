//
//  NSArray+Iterable.h
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-28.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Iterable)

- (NSArray *)map:(id (^)(id obj))block;
- (NSArray *)select:(BOOL (^)(id obj))block;
- (id)reduce:(id (^)(id memo, id obj))block;
- (id)fromSeed:(id)seed reduce:(id (^)(id memo, id obj))block;

@end
