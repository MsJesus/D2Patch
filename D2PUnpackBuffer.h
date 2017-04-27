//
//  D2PUnpackBuffer.h
//  D2Patch
//
//  Created by Andrey on 23/02/2017.
//

#import <Foundation/Foundation.h>
#import "D2PTextureDescriptor.h"


@interface D2PUnpackBuffer : NSObject
{
    D2PTextureDescriptor    *_descriptor;
    GLuint                  _bName;
}

@property (nonatomic, readonly) D2PTextureDescriptor *descriptor;
@property (nonatomic, readonly) BOOL isValid;
@property (nonatomic, readonly) GLuint name;

+ (NSUInteger) totalSize;

- (instancetype) initWithDescriptor:(D2PTextureDescriptor *)descriptor;

- (void) withBuffer:(void (NS_NOESCAPE ^)())block;

- (void) invalidate;

@end
