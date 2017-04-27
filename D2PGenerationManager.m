//
//  D2PGenerationManager.m
//  D2Patch
//
//  Created by Andrey on 23/02/2017.
//

#import "D2PGenerationManager.h"


@implementation D2PGenerationManager


- (instancetype) initWithGenerationsCount:(NSUInteger)count
{
    self = [super init];
    if (self)
    {
        if (count >= 2)
        {
            _data = [NSMutableArray arrayWithCapacity:count];
            
            for (NSUInteger i = 0; i < count; i++)
            {
                [_data addObject:[NSMutableSet set]];
            }
        }
        else
        {
            return nil;
        }
    }
    
    return self;
}


- (void) addFreshObject:(id)object
{
    [self removeObject:object];
    
    [_data.lastObject addObject:object];
}


- (void) removeObject:(id)object
{
    for (NSMutableSet *s in _data)
    {
        [s removeObject:object];
    }
}


- (void) shiftDownGenerations
{
    for (NSUInteger i = 0; i < (_data.count - 1); i++)
    {
        NSMutableSet *oldSet = _data[i];
        NSMutableSet *youngSet = _data[i+1];
        
        [oldSet unionSet:youngSet];
        [youngSet removeAllObjects];
    }
}


- (id) anyOldestObject
{
    return [_data[0] anyObject];
}


@end

