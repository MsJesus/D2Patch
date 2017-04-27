//
//  D2PUnpackBufferCache.m
//  D2Patch
//
//  Created by Andrey on 23/02/2017.
//

#import "D2PUnpackBufferCache.h"

#import <CommonCrypto/CommonDigest.h>


@interface D2PUnpackBufferCacheData : NSObject
{
    D2PUnpackBuffer     *_buffer;
    NSDate              *_lastUseDate;
}

@property (nonatomic, readonly) D2PUnpackBuffer *buffer;
@property (nonatomic, strong) NSDate *lastUseDate;

- (instancetype) initWithBuffer:(D2PUnpackBuffer *)buffer;

@end


@implementation D2PUnpackBufferCacheData

@synthesize buffer = _buffer;
@synthesize lastUseDate = _lastUseDate;


- (instancetype) initWithBuffer:(D2PUnpackBuffer *)buffer
{
    self = [super init];
    if (self)
    {
        _buffer = buffer;
    }
    
    return self;
}


@end





@implementation D2PUnpackBufferCache


+ (instancetype) sharedInstance
{
    @synchronized (self)
    {
        static D2PUnpackBufferCache *__sharedInstance = nil;
        
        if (__sharedInstance == nil)
        {
            __sharedInstance = [[D2PUnpackBufferCache alloc] init];
        }
        
        return __sharedInstance;
    }
}


- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _cache = [NSMutableDictionary dictionary];
        _cacheByName = [NSMutableDictionary dictionary];
        _bufferGenerations = [[D2PGenerationManager alloc] initWithGenerationsCount:3];
        _lastCleanDate = [NSDate date];
        _lastEfficiencyLogDate = [NSDate date];
    }
    
    return self;
}


- (void) addBuffer:(D2PUnpackBuffer *)buffer
{
    if (buffer != nil)
    {
        D2PTextureHash *hashKey = buffer.descriptor.textureHash;
        NSNumber *nameKey = @(buffer.name);
        
        [self removeBuffer:[_cache objectForKey:hashKey]];
        [self removeBuffer:[_cacheByName objectForKey:nameKey]];
        
        [_cache setObject:buffer forKey:hashKey];
        [_cacheByName setObject:buffer forKey:nameKey];
        
        [_bufferGenerations addFreshObject:buffer];
    }
}


- (void) removeBuffer:(D2PUnpackBuffer *)buffer
{
    if (buffer != nil)
    {
        D2PTextureHash *hashKey = buffer.descriptor.textureHash;
        NSNumber *nameKey = @(buffer.name);
        
        [_cache removeObjectForKey:hashKey];
        [_cacheByName removeObjectForKey:nameKey];
        
        [_bufferGenerations removeObject:buffer];
    }
}


- (D2PUnpackBuffer *) bufferForDescriptor:(D2PTextureDescriptor *)descriptor
{
    @synchronized (_cache)
    {
        NSDate *date = [NSDate date];
        
        if ([date timeIntervalSinceDate:_lastEfficiencyLogDate] > 10.0)
        {
            CGFloat efficiency = ((CGFloat) _cachedCount) / ((CGFloat) _cachedCount + _missesCount);
            CGFloat totalSizeMB = ((CGFloat) [D2PUnpackBuffer totalSize]) / (1024. * 1024.);
            NSLog(@"Efficiency = %@, total size %@", @(efficiency), @(totalSizeMB));
            
            _missesCount = 0;
            _cachedCount = 0;
            _lastEfficiencyLogDate = date;
        }
        
        
        if ([date timeIntervalSinceDate:_lastCleanDate] > 30.)
        {
            [_bufferGenerations shiftDownGenerations];
            
            _lastCleanDate = date;
        }
        
        
        for (NSUInteger i = 0; i < 2; i++)
        {
            [self removeBuffer:_bufferGenerations.anyOldestObject];
        }
        
        
        
        D2PUnpackBuffer *cachedBuffer = [_cache objectForKey:descriptor.textureHash];
        
        if (cachedBuffer == nil || !cachedBuffer.isValid)
        {
            D2PUnpackBuffer *newBuffer = [[D2PUnpackBuffer alloc] initWithDescriptor:descriptor];
        
            [self addBuffer:newBuffer];
            
            _missesCount += 1;
            
            return newBuffer;
        }
        else
        {
            [_bufferGenerations addFreshObject:cachedBuffer];
            
            _cachedCount += 1;
            
            return cachedBuffer;
        }
    }
}


- (void) invalidateName:(GLuint)name
{
    @synchronized (_cache)
    {
        D2PUnpackBuffer *buffer = [_cacheByName objectForKey:@(name)];
        if (buffer != nil)
        {
            [buffer invalidate];
            [self removeBuffer:buffer];
        }
    }
}


@end

