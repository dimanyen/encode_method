//
//  MyEncodeAlgorithm.m
//  MyOTPlib0713
//
//  Created by yen diman on 12/7/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyEncodeAlgorithm.h"

@implementation MyEncodeAlgorithm



+(NSData*) SetNSDataSize:(NSData*)data setSize:(NSInteger)size
{
    Byte zero[size - data.length];
    memset (zero, 0, (size - data.length * sizeof(Byte)));
    NSMutableData* result = [NSMutableData dataWithData:data];
    [result appendBytes:zero length:size-data.length];
    return result;
}


+(NSData *) SetNSDataSizePaddingLeft:(NSData *)data setSize:(NSInteger)size
{
    Byte zero[size - data.length];
    memset (zero, 0, (size - data.length * sizeof(Byte)));
    NSMutableData* result = [NSMutableData dataWithBytes:zero length:size - data.length];
    [result appendData:data];
    return result;
}

+(NSData*) NSDataXor:(NSData*) da1 withData:(NSData*) da2
{
    NSData *result = [da1 mutableCopy];
    //NSLog(@"t1:%@, t2:%@",da1,da2);
    char *dataPtr = (char *) [result bytes];
    char *keyData = (char *) [da2 bytes];
    char *keyPtr = keyData;
    int keyIndex = 0;
    for (int x = 0; x < [da1 length]; x++) 
    {
        
        *dataPtr = *dataPtr ^ *keyPtr; 
        
        if (++keyIndex == [da2 length])
            keyIndex = 0, keyPtr = keyData;
        dataPtr++;
        keyPtr++;
    }
    
    return result;
}

+(Boolean) isNumeric:(NSString *)inputString
{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    //[stringSet release];
    return isValid;
}

+(NSData *) SHA384Encode:(NSData *)data
{
    void* buffer = malloc(CC_SHA384_DIGEST_LENGTH);
    CC_SHA384([data bytes], data.length, buffer);
    return [NSData dataWithBytesNoCopy:buffer length:CC_SHA384_DIGEST_LENGTH freeWhenDone:YES];
}

+(NSData *) SHA1Encode:(NSData *)data
{
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
//    void* buffer = malloc(CC_SHA1_DIGEST_LENGTH);
    CC_SHA1(data.bytes, data.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

+(NSData *) HMacSHA1Encode:(NSData *)key andData:(NSData *)data
{
    void* buffer = malloc(CC_SHA1_DIGEST_LENGTH);
    CCHmac(kCCHmacAlgSHA1, [key bytes], [key length], [data bytes], [data length], buffer);
    return [NSData dataWithBytesNoCopy:buffer length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
}

+(NSData *) TripleDesEncode:(NSData *)data key:(NSData *)key encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    key = [key subdataWithRange:NSMakeRange(0, 24)];
    const void *vplainText = [data bytes];
    size_t plainTextBufferSize = [data length];
    vplainText = (const void *) [data bytes];
//    NSLog(@"data:%@",data);
//    NSLog(@"key:%@",key);
    
    //CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t iv[kCCBlockSize3DES];
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //NSString *key = @"123456789012345678901234";
    //NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [key bytes];
    //const void *vinitVec = (const void *) [initVec UTF8String];
    
    CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode,
                       vkey, 
                       kCCKeySize3DES,
                       nil, 
                       vplainText, 
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    
    
    NSData *result = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    return result;
}

+(NSData *) MD5:(NSData *)data
{
    unsigned char result[16];
    CC_MD5([data bytes], data.length, result);
    return [NSData dataWithBytes:result length:16];
    
}

+(NSData *) LongToNSData:(long long)data
{
    Byte *buf = (Byte*)malloc(8);
    for (int i=7; i>=0; i--) {
        buf[i] = data & 0x00000000000000ff;
        data = data >> 8;
    }
    
    NSData *result =[NSData dataWithBytes:buf length:8];
    return result;
}

+(NSData *) IntToNSData:(NSInteger)data
{
    Byte *byteData = (Byte*)malloc(4);
    byteData[3] = data & 0xff;
    byteData[2] = (data & 0xff00) >> 8;
    byteData[1] = (data & 0xff0000) >> 16;
    byteData[0] = (data & 0xff000000) >> 24;
    NSData * result = [NSData dataWithBytes:byteData length:4];
    NSLog(@"result=%@",result);
    return (NSData*)result;
}

+(uint32_t) NSDataToUInt:(NSData *)data
{
    unsigned char bytes[4];
    [data getBytes:bytes length:4];
    uint32_t n = (int)bytes[0] << 24;
    n |= (int)bytes[1] << 16;
    n |= (int)bytes[2] << 8;
    n |= (int)bytes[3];
    return n;
}

+(NSInteger) NSDataToInt:(NSData *)data
{
    unsigned char bytes[4];
    [data getBytes:bytes length:4];
    NSInteger n = (int)bytes[0] << 24;
    n |= (int)bytes[1] << 16;
    n |= (int)bytes[2] << 8;
    n |= (int)bytes[3];
    return n;
}

+(NSData *) hexStrToNSData:(NSString *)data withSize:(NSInteger)size
{
    int add = size*2 - data.length;
    
    if (add > 0) {
        NSString* tmp = [[NSString string] stringByPaddingToLength:add withString:@"0" startingAtIndex:0];
        data = [tmp stringByAppendingString:data];
    }
    
    return [self hexStrToNSData:data];
}

+(NSData *) hexStrToNSData:(NSString *)hexStr
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= hexStr.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* ch = [hexStr substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:ch];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+(NSString *) NSDataToHexString:(NSData *)data
{
    if (data == nil) {
        return nil;
    }
    NSMutableString* hexString = [NSMutableString string];
    const unsigned char *p = [data bytes];
    for (int i=0; i < [data length]; i++) {
        [hexString appendFormat:@"%02x", *p++];
    }
    return hexString;
}

@end
