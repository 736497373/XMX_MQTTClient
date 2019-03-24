//
//  XMX_MQTTClientViewController.m
//  XMX_MQTTClient
//
//  Created by 736497373 on 01/15/2019.
//  Copyright (c) 2019 736497373. All rights reserved.
//

#import "XMX_MQTTClientViewController.h"
#import <XMX_MQTTClient/XMX_MQTTClientManager.h>
@interface XMX_MQTTClientViewController () <XMX_MQTTDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation XMX_MQTTClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)connectionButtonAction:(id)sender {
    
    if (self.ipTextField.text.length > 0 && self.portTextField.text.length > 0) {
        [[XMX_MQTTClientManager shareInstance] loginWithIp:self.ipTextField.text
                                                      port:[self.portTextField.text intValue]
                                                  userName:self.userNameTextField.text
                                                  password:self.password.text
                                          cleanSessionFlag:false
                                             isAutoConnect:true
                                       autoConnectInterval:0.5
                                                DDLogLevel:(DDLogLevelOff)];
        
        
        [self performSegueWithIdentifier:@"tabbarController" sender:self];
    }
    
  

    
    
}


@end
