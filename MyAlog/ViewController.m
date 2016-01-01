//
//  ViewController.m
//  MyAlog
//
//  Created by Diman on 2016/1/1.
//  Copyright © 2016年 DM. All rights reserved.
//

#import "ViewController.h"
#import "MyEncodeAlgorithm.h"
#import "NSString+hexToBytes.h"
#import "NSString+MD5Addition.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *dataString = @"hello world";
    
    NSInteger len = 2;
    while (len < dataString.length) {
        len = (NSInteger)pow(len, 2);
    }
    
    NSData *data = [NSData dataWithBytes:[dataString UTF8String] length:len];
    
    
    NSData *keyData = [@"FFFFFFFFFF" hexToBytes];
    keyData = [MyEncodeAlgorithm SetNSDataSize:keyData setSize:24];
    
    NSData *encodeData = [MyEncodeAlgorithm TripleDesEncode:data key:keyData encryptOrDecrypt:kCCEncrypt];
    
    NSLog(@"encode Data: %@",[MyEncodeAlgorithm NSDataToHexString:encodeData]);
    
    NSData *decodeData = [MyEncodeAlgorithm TripleDesEncode:encodeData key:keyData encryptOrDecrypt:kCCDecrypt];
    
    NSLog(@"data: %@",[NSString stringWithUTF8String:[decodeData bytes]]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
