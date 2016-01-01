//
//  MyBase64.h
//  MyOTPlib0713
//
//  Created by Diman Yen on 12/8/5.
//
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
-(id)initWithBase64EncodedString:(NSString *)string;

- (NSString *) base64Encoding;
-(NSString *) base64EncodingWithLineLength:(unsigned int) lineLength;

@end
