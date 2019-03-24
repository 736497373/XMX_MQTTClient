//
//  item2ViewController.m
//  XMX_MQTTClient_Example
//
//  Created by Sierra on 2019/1/15.
//  Copyright © 2019 736497373. All rights reserved.
//

#import "item2ViewController.h"
#import <XMX_MQTTClient/XMX_MQTTClientManager.h>
@interface item2ViewController () <XMX_MQTTDelegate>
@property (weak, nonatomic) IBOutlet UITextView *logTextField;

@end

@implementation item2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[XMX_MQTTClientManager shareInstance] bind:self];
}

- (void)MQTT_messageTopic:(NSString *)topic messageDic:(NSDictionary *)messageDic {
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDic options:0 error:0];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    self.logTextField.text = [self.logTextField.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",dataStr]];
    
    
}

@end
