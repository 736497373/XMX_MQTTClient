# XMX_MQTTClient

[![CI Status](https://img.shields.io/travis/736497373/XMX_MQTTClient.svg?style=flat)](https://travis-ci.org/736497373/XMX_MQTTClient)
[![Version](https://img.shields.io/cocoapods/v/XMX_MQTTClient.svg?style=flat)](https://cocoapods.org/pods/XMX_MQTTClient)
[![License](https://img.shields.io/cocoapods/l/XMX_MQTTClient.svg?style=flat)](https://cocoapods.org/pods/XMX_MQTTClient)
[![Platform](https://img.shields.io/cocoapods/p/XMX_MQTTClient.svg?style=flat)](https://cocoapods.org/pods/XMX_MQTTClient)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XMX_MQTTClient is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XMX_MQTTClient',:git => 'https://github.com/736497373/XMX_MQTTClient'
```


## Usage

### 基础用法
```ruby

// 登录MQTT
 [[XMX_MQTTClientManager shareInstance] loginWithIp:MQTT_brokerURL
                                        port:MQTT_port
                                        userName:MQTT_userName
                                        password:MQTT_password
                                        cleanSessionFlag:false
                                        isAutoConnect:true
                                        autoConnectInterval:60];

// 订阅xxxx标签
[XMX_MQTTClientManager shareInstance] addTopic:@"xxxx"];

// 删除xxxx标签
[XMX_MQTTClientManager shareInstance] delTopic:@"xxxx"];

```


### 代理 XMX_MQTTDelegate
#### 注册
```ruby
// 绑定MQTT代理
[XMX_MQTTClientManager shareInstance] bind:self]

// 解绑MQTT代理
[XMX_MQTTClientManager shareInstance] unbind:self]

```

#### 回调
```ruby
//  绑定MQTT代理页面，接受NSDictionary参数回调
-(void)MQTT_messageTopic:(NSString *)topic messageDic:(NSDictionary *)messageDic;

// //  绑定MQTT代理页面，接受NNSString参数回调
-(void)MQTT_messageTopic:(NSString *)topic messageStr:(NSString *)messageStr;

```




## Author

736497373@qq.com

## License

XMX_MQTTClient is available under the MIT license. See the LICENSE file for more info.
