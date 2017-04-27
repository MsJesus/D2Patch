//
//  D2PGenerationManager.h
//  D2Patch
//
//  Created by Andrey on 23/02/2017.
//

#import <Foundation/Foundation.h>


@interface D2PGenerationManager<ObjectType> : NSObject
{
    NSMutableArray<NSMutableSet<ObjectType> *>    *_data;
}

- (instancetype) initWithGenerationsCount:(NSUInteger)count;

- (void) addFreshObject:(ObjectType)object;
- (void) removeObject:(ObjectType)object;
- (void) shiftDownGenerations;

- (ObjectType) anyOldestObject;

@end

