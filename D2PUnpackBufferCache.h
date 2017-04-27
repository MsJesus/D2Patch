//
//  D2PUnpackBufferCache.h
//  D2Patch
//
//  Created by Andrey on 23/02/2017.
//

#import <Foundation/Foundation.h>

#import "D2PUnpackBuffer.h"
#import "D2PGenerationManager.h"


@class D2PUnpackBufferCacheData;

@interface D2PUnpackBufferCache : NSObject
{
    NSMutableDictionary<D2PTextureHash *, D2PUnpackBuffer *>    *_cache;
    NSMutableDictionary<NSNumber *, D2PUnpackBuffer *>          *_cacheByName;
    D2PGenerationManager<D2PUnpackBuffer *>                     *_bufferGenerations;
    NSDate      *_lastCleanDate;
    
    NSDate      *_lastEfficiencyLogDate;
    NSUInteger  _missesCount;
    NSUInteger  _cachedCount;
}

+ (instancetype) sharedInstance;

- (D2PUnpackBuffer *) bufferForDescriptor:(D2PTextureDescriptor *)descriptor;

- (void) invalidateName:(GLuint)name;

@end

