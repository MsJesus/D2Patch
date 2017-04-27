//
//  D2PUnpackBuffer.m
//  D2Patch
//
//  Created by Andrey on 23/02/2017.
//

#import "D2PUnpackBuffer.h"

#import "D2PUnpackBufferCache.h"


static NSUInteger __totalSize = 0;


@implementation D2PUnpackBuffer

@synthesize descriptor = _descriptor;
@synthesize name = _bName;


+ (NSUInteger) totalSize
{
    return __totalSize;
}


- (instancetype) initWithDescriptor:(D2PTextureDescriptor *)descriptor
{
    self = [super init];
    if (self)
    {
        _descriptor = descriptor;
        
        glGenBuffers(1, &_bName);
        if (_bName == 0)
        {
            NSLog(@"Zero buffer name");
            return nil;
        }
        else
        {
            [[D2PUnpackBufferCache sharedInstance] invalidateName:_bName];
        }

        
        [self withBuffer:^{
            
            glBufferData(GL_PIXEL_UNPACK_BUFFER, descriptor.size, descriptor.pixels, GL_STATIC_DRAW);
            
        }];
        
        
        __totalSize += descriptor.size;
    }
    
    return self;
}


- (void) dealloc
{
    __totalSize -= self.descriptor.size;
    
    if (_bName != 0 && self.isValid)
    {
        glDeleteBuffers(1, &_bName);
    }
}


- (void) withBuffer:(void (NS_NOESCAPE ^)())block
{
    if (_bName != 0)
    {
        GLint oldBuffer;
        glGetIntegerv(GL_PIXEL_UNPACK_BUFFER_BINDING, &oldBuffer);
        
        glBindBuffer(GL_PIXEL_UNPACK_BUFFER, _bName);
        
        block();
        
        glBindBuffer(GL_PIXEL_UNPACK_BUFFER, oldBuffer);
    }
    else
    {
        [NSException raise:@"Fatal error" format:@"Use of invalid buffer"];
    }
}


- (BOOL) isValid
{
    return glIsBuffer(_bName);
}


- (void) invalidate
{
    _bName = 0;
}


@end

