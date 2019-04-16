//
//  item1ViewController.m
//  XMX_MQTTClient_Example
//
//  Created by Sierra on 2019/1/15.
//  Copyright © 2019 736497373. All rights reserved.
//

#import "item1ViewController.h"
#import <XMX_MQTTClient/XMX_MQTTClientManager.h>
@interface item1ViewController () <XMX_MQTTDelegate>
@property (weak, nonatomic) IBOutlet UITextField *topicTextField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation item1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[XMX_MQTTClientManager shareInstance] bind:self];
    
}

- (void)MQTT_messageTopic:(NSString *)topic messageDic:(NSDictionary *)messageDic {
    if (messageDic) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDic options:0 error:0];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        self.logTextView.text = [self.logTextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",dataStr]];
    }
}


- (void)MQTT_messageTopic:(NSString *)topic messageStr:(NSString *)messageStr {
    self.logTextView.text = [self.logTextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",messageStr]];
}






- (IBAction)addTopicButtonAction:(id)sender {
    if (self.topicTextField.text.length > 0) {
        [[XMX_MQTTClientManager shareInstance] addTopic:self.topicTextField.text];
    }
}

- (IBAction)delTopicButtonAction:(id)sender {
    if (self.topicTextField.text.length > 0) {
        [[XMX_MQTTClientManager shareInstance] delTopic:self.topicTextField.text];
    }
}

- (IBAction)clearTopicButton:(id)sender {
    [[XMX_MQTTClientManager shareInstance] clearTopic];
    self.logTextView.text = nil;
}




@end
