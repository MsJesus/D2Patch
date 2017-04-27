//
//  D2PTextureHash.h
//  D2Patch
//
//  Created by Andrey on 23/02/2017.
//

#import <Foundation/Foundation.h>


@interface D2PTextureHash : NSObject <NSCopying>
{
    NSData          *_data;
}

- (instancetype) initWithData:(const void *)data length:(NSUInteger)length;

@end

