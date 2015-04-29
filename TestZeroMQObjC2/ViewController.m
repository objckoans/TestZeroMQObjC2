//
//  ViewController.m
//  TestZeroMQObjC2
//
//  Created by Calvin Cheng on 28/4/15.
//  Copyright (c) 2015 Hello HQ Pte. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "ZMQObjC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) requestZMQ
{
    ZMQContext *ctx = [[ZMQContext alloc] initWithIOThreads:1];
    NSString *endpoint = @"tcp://192.168.1.10:9900";
    ZMQSocket *requester = [ctx socketWithType:ZMQ_REQ];

    BOOL didConnect = [requester connectToEndpoint:endpoint];
    if (!didConnect) {
        NSLog(@"*** Failed to connect to endpoint [%@].", endpoint);
    }
    NSData *request = [@"13599832991039421,user1,123,getHistory,^XAUUSD,2,1,10,4EC514F8CDA44339A3367E7ECF53BC1E" dataUsingEncoding:NSUTF8StringEncoding];
    
    int kMaxRequest = 10;
    for (int request_nbr = 0; request_nbr < kMaxRequest; ++request_nbr) {
        
        // send data
        [requester sendData:request withFlags:0];
        NSLog(@"Sending request %d", request_nbr);
        
        // receive data
        NSData *reply = [requester receiveDataWithFlags:0];
        NSString *text = [[NSString alloc] initWithData:reply encoding:NSUTF8StringEncoding];
        NSLog(@"Received reply %d: %@", request_nbr, text);
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Hello");
    [self requestZMQ];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
