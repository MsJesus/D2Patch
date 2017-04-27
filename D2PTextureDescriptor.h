//
//  D2PTextureDescriptor.h
//  D2Patch
//
//  Created by Andrey on 23/02/2017.
//

#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>

#import "D2PTextureHash.h"


@interface D2PTextureDescriptor : NSObject
{
    GLsizei         _width;
    GLsizei         _height;
    GLenum          _format;
    GLenum          _type;
    const GLvoid    *_pixels;
    
    D2PTextureHash  *_textureHash;
}

@property (nonatomic, readonly) GLsizei width;
@property (nonatomic, readonly) GLsizei height;
@property (nonatomic, readonly) GLenum format;
@property (nonatomic, readonly) GLenum type;
@property (nonatomic, readonly) const GLvoid *pixels;
@property (nonatomic, readonly) NSUInteger bytesPerPixel;
@property (nonatomic, readonly) NSUInteger area;
@property (nonatomic, readonly) NSUInteger size;
@property (nonatomic, readonly) D2PTextureHash *textureHash;

- (instancetype) initWithData:(const GLvoid *)pixels
                        width:(GLsizei)width
                       height:(GLsizei)height
                       format:(GLenum)format
                         type:(GLenum)type;

@end

