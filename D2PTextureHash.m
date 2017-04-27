//
//  D2PTextureHash.m
//  D2Patch
//
//  Created by Andrey on 23/02/2017.
//

#import "D2PTextureHash.h"

#import <CommonCrypto/CommonDigest.h>



@implementation D2PTextureHash


- (instancetype) initWithData:(const void *)data length:(NSUInteger)length
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, length, result);
    
    NSData *value = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    
    return [self initWithPlainValue:value];
}


- (instancetype) initWithPlainValue:(NSData *)value
{
    self = [super init];
    if (self)
    {
        _data = value;
    }
    
    return self;
}


- (BOOL) isEqual:(id)object
{
    if ([object isMemberOfClass:[D2PTextureHash class]])
    {
        D2PTextureHash *otherHash = (D2PTextureHash *)object;
        
        return [_data isEqualToData:otherHash->_data];
    }
    else
    {
        return NO;
    }
}


- (NSUInteger) hash
{
    return _data.hash;
}


- (instancetype) copyWithZone:(NSZone *)zone
{
    return [[D2PTextureHash alloc] initWithPlainValue:_data];
}


- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ = %@>", NSStringFromClass(self.class), _data];
}


@end

