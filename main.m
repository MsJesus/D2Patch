//
//  main.m
//  D2Patch
//
//  Created by Andrey on 22/02/2017.
//

#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>
#import <OpenGL/OpenGL.h>

#import "D2PUnpackBufferCache.h"


// run
// cd /Applications/Diablo\ II/Diablo\ II.app/Contents/MacOS/
// DYLD_INSERT_LIBRARIES=~/Desktop/libD2Patch.dylib ./Diablo\ II


#define DYLD_INTERPOSE(_replacment,_replacee) \
__attribute__((used)) static struct{ const void* replacment; const void* replacee; } _interpose_##_replacee \
__attribute__ ((section ("__DATA,__interpose"))) = { (const void*)(unsigned long)&_replacment, (const void*)(unsigned long)&_replacee };


void hooked_glTexSubImage2D (
                             GLenum target,
                             GLint level,
                             GLint xoffset,
                             GLint yoffset,
                             GLsizei width,
                             GLsizei height,
                             GLenum format,
                             GLenum type,
                             const GLvoid *pixels
                             )
{
    @autoreleasepool
    {
        D2PTextureDescriptor *descriptor = [[D2PTextureDescriptor alloc] initWithData:pixels
                                                                                width:width
                                                                               height:height
                                                                               format:format
                                                                                 type:type];
        
        D2PUnpackBuffer *buffer = [[D2PUnpackBufferCache sharedInstance] bufferForDescriptor:descriptor];
        
        if (buffer != nil)
        {
            [buffer withBuffer:^{
                glTexSubImage2D(target, level, xoffset, yoffset, width, height, format, type, (const GLvoid *) 0);
            }];
        }
        else
        {
            glTexSubImage2D(target, level, xoffset, yoffset, width, height, format, type, pixels);
        }
    }
}


DYLD_INTERPOSE(hooked_glTexSubImage2D, glTexSubImage2D);




__attribute__((constructor)) void load()
{
    NSLog(@"constructor called");
}


