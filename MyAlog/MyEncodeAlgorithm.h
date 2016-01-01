//
//  MyEncodeAlgorithm.h
//  MyOTPlib0713
//
//  Created by yen diman on 12/7/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import "GTMBase64.h"

@interface MyEncodeAlgorithm : NSObject

+(NSData *) TripleDesEncode:(NSData*)data key:(NSData*)key encryptOrDecrypt:(CCOperation)encryptOrDecrypt;
+(NSData *) HMacSHA1Encode:(NSData*) key andData:(NSData*) data;
+(NSData *) MD5:(NSData *)data;
+(NSData *) SHA384Encode:(NSData *)data;
+(NSData *) SHA1Encode:(NSData *)data;
+(NSData *) hexStrToNSData:(NSString *)hexStr;
+(NSData *) hexStrToNSData:(NSString *)data withSize:(NSInteger)size;
+(NSString *) NSDataToHexString:(NSData*)data;
+(Boolean) isNumeric:(NSString*)inputString;
+(NSData *) IntToNSData:(NSInteger)data;
+(NSData *) LongToNSData:(long long)data;
+(NSInteger) NSDataToInt:(NSData *)data;
+(uint32_t) NSDataToUInt:(NSData *)data;
+(NSData*) NSDataXor:(NSData*) da1 withData:(NSData*) da2;
+(NSData*) SetNSDataSize:(NSData*)data setSize:(NSInteger)size;
+(NSData *) SetNSDataSizePaddingLeft:(NSData *)data setSize:(NSInteger)size;

@end
