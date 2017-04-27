//
//  D2PTextureDescriptor.m
//  D2Patch
//
//  Created by Andrey on 23/02/2017.
//

#import "D2PTextureDescriptor.h"



@implementation D2PTextureDescriptor

@synthesize width = _width;
@synthesize height = _height;
@synthesize format = _format;
@synthesize type = _type;
@synthesize pixels = _pixels;
@synthesize textureHash = _textureHash;


- (instancetype) initWithData:(const GLvoid *)pixels
                        width:(GLsizei)width
                       height:(GLsizei)height
                       format:(GLenum)format
                         type:(GLenum)type
{
    self = [super init];
    if (self)
    {
        _width = width;
        _height = height;
        _format = format;
        _type = type;
        _pixels = pixels;
        
        _textureHash = [[D2PTextureHash alloc] initWithData:pixels length:self.size];
    }
    
    return self;
}


- (BOOL) isEqual:(id)object
{
    if ([object isMemberOfClass:[D2PTextureDescriptor class]])
    {
        D2PTextureDescriptor *otherDescriptor = (D2PTextureDescriptor *) object;
        
        return _width == otherDescriptor->_width
        && _height == otherDescriptor->_height
        && _format == otherDescriptor->_format
        && _type == otherDescriptor->_type
        && _pixels == otherDescriptor->_pixels;
    }
    else
    {
        return NO;
    }
}


- (NSUInteger) hash
{
    return @(_width).hash
    + @(_height).hash
    + @(_format).hash
    + @(_type).hash
    + ((NSUInteger) _pixels);
}


- (NSUInteger) bytesPerPixel
{
    switch (self.type)
    {
        case GL_UNSIGNED_SHORT_1_5_5_5_REV:
            return 2;
            
        default:
            [NSException raise:@"Fatal error" format:@"Unknow texture size"];
            return 0;
    }
}


- (NSUInteger) area
{
    return self.width * self.height;
}


- (NSUInteger) size
{
    return self.area * self.bytesPerPixel;
}


@end

