//
//  CRC.h
//  MyOTPlib0713
//
//  Created by yen diman on 12/7/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRC :NSObject

+(uint32_t) crc32:(NSData *)data;
+(uint32_t) crc32WithSeed:(uint32_t)seed data:(NSData *)data; 
+(uint32_t) crc32UsingPolynomial:(uint32_t)poly data:(NSData *)data;
+(uint32_t) crc32WithSeed:(uint32_t)seed usingPolynomial:(uint32_t)poly data:(NSData *)data;

@end
