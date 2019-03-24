//
//  XMX_MQTTClientManager.m
//  MQTTClient
//
//  Created by Sierra on 2019/1/15.
//

#import "XMX_MQTTClientManager.h"


@interface XMX_MQTTClientManager() <MQTTSessionDelegate>



@property (nonatomic, strong)   NSHashTable<id<XMX_MQTTDelegate>> *delegates;

/**
 IP地址
 */
@property(nonatomic, strong)    NSString *ip;

/**
 端口
 */
@property(nonatomic, assign)    UInt16 port;


/**
 登录名
 */
@property(nonatomic, strong)    NSString *userName;


/**
 密码
 */
@property(nonatomic, strong)    NSString *password;


/**
 多订阅
 */
@property(nonatomic, strong)    NSMutableArray *topicArray;

/**
 是否自动重连
 */
@property(nonatomic, assign)    BOOL   isAutoConnect;


/**
 是否清除session
 */
@property(nonatomic, assign)    BOOL   cleanSessionFlag;


/**
 保活时间
 */
@property(nonatomic, assign)    NSInteger   keepAliveInterval;


/**
 重连间隔
 */
@property(nonatomic, assign)    NSInteger   autoConnectInterval;

/**
 MQTTSession
 */
@property(nonatomic, strong)    MQTTSession *mqttSession;


/**
 连接服务器属性
 */
@property(nonatomic, strong)    MQTTCFSocketTransport *transport;
@end

@implementation XMX_MQTTClientManager


/**
 单例
 
 @return self
 */
+(XMX_MQTTClientManager *)shareInstance{
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc] init];
    });
    return instance;
}


-(void)loginWithIp:(NSString *)ip
              port:(UInt16)port
          userName:(NSString *)userName
          password:(NSString *)password
  cleanSessionFlag:(BOOL)cleanSessionFlag
     isAutoConnect:(BOOL)isAutoConnect
autoConnectInterval:(NSInteger)autoConnectInterval
         DDLogLevel:(DDLogLevel)LogLevel{
    
    [MQTTLog setLogLevel:LogLevel];
    
    NSParameterAssert(ip&&(![ip isEqualToString:@""]));
    NSParameterAssert(port);
    
    self.ip=ip;
    self.port=port;
    self.userName=userName;
    self.password=password;
    self.isAutoConnect=isAutoConnect;
    self.cleanSessionFlag = cleanSessionFlag;
    
    self.autoConnectInterval = autoConnectInterval ? : 0.3;
    
    
    [self login];
    
}



-(void)login {
    NSLog(@"-----------------MQTT登陆-----------------");
    self.transport.host=_ip;
    self.transport.port=_port;
    
    self.mqttSession.transport=self.transport;
    self.mqttSession.delegate=self;
    if (_userName.length > 0) {
        [self.mqttSession setUserName:_userName];
    }
    
    if (_password.length > 0) {
      [self.mqttSession setPassword:_password];
    }
    
  
    [self.mqttSession setCleanSessionFlag:_cleanSessionFlag];
    
    //会话链接并设置超时时间
    [self.mqttSession connectAndWaitTimeout:20];
}

-(void)close {
    
    NSLog(@"-----------------MQTT断开连接-----------------");
    [_mqttSession disconnect];
    _delegates=nil;
    _mqttSession=nil;
    _transport=nil;
    _ip=nil;
    _port=0;
    _userName=nil;
    _password=nil;
    [_topicArray removeAllObjects];
    _topicArray = nil;
    _isAutoConnect=nil;
}


- (void)handleEvent:(MQTTSession *)session event:(MQTTSessionEvent)eventCode error:(NSError *)error {
    NSDictionary *events = @{
                             @(MQTTSessionEventConnected): @"connected",
                             @(MQTTSessionEventConnectionRefused): @"账号或密码错误，服务器拒绝连接",
                             @(MQTTSessionEventConnectionClosed): @"connection closed",
                             @(MQTTSessionEventConnectionError): @"connection error",
                             @(MQTTSessionEventProtocolError): @"protocoll error",
                             @(MQTTSessionEventConnectionClosedByBroker): @"connection closed by broker"
                             };
    
    
    NSLog(@"-----------------MQTT连接状态%@-----------------",[events objectForKey:@(eventCode)]);
    
    switch (eventCode) {
        case MQTTSessionEventConnected: {
            
            if (self.topicArray.count > 0) {
                for (NSString *topic in self.topicArray) {
                    [self.mqttSession subscribeToTopic:topic atLevel:(MQTTQosLevelAtLeastOnce)];
                    NSLog(@"-----------------MQTT成功订阅 %@-----------------",topic);
                }
            }
            
            [self handleMQTTResults:events event:eventCode];
        }break;
        case MQTTSessionEventConnectionClosed:{
        }break;
        case MQTTSessionEventConnectionRefused:{
            [self handleMQTTResults:events event:eventCode];
        }break;
        default:{
            self.isAutoConnect ? [self performSelector:@selector(login) withObject:nil afterDelay:_autoConnectInterval] : [self handleMQTTResults:events event:eventCode];
        }
            break;
    }
}


/*处理服务器结果*/
-(void)handleMQTTResults:(NSDictionary *)events event:(MQTTSessionEvent)eventCode{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@(eventCode) forKey:@"eventCode"];
    [dic setObject:[events objectForKey:@(eventCode)] forKey:@"event"];
    
    
    for (id<XMX_MQTTDelegate> delegate in [self.delegates setRepresentation]) {
        if (delegate && [delegate respondsToSelector:@selector(MQTT_didReceiveServerStatus:)]) {
            [delegate MQTT_didReceiveServerStatus:dic];
        }
    }
    
}


- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    NSString *jsonStr=[NSString stringWithUTF8String:data.bytes];
    NSLog(@"-----------------MQTT收到消息-----------------\nTopic:%@  \n内容：%@",topic,jsonStr);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    for (id<XMX_MQTTDelegate> delegate in [self.delegates setRepresentation]) {
        if (delegate && [delegate respondsToSelector:@selector(MQTT_messageTopic:messageDic:)]) {
            [delegate MQTT_messageTopic:topic messageDic:dic];
        }
    }
}





- (void)bind:(id<XMX_MQTTDelegate>)delegate {
    
    if (!delegate) return;
    if (![delegate conformsToProtocol:@protocol(XMX_MQTTDelegate)]) return;
    
    if (![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
        NSLog(@"MQTT绑定代理对象 = %@",NSStringFromClass([delegate class]));
    }
}

- (void)unbind:(id<XMX_MQTTDelegate>)delegate {
    
    if (!delegate) return;
    if ([self.delegates containsObject:delegate]) {
        [self.delegates removeObject:delegate];
        NSLog(@"MQTT解除绑定代理对象 = %@",NSStringFromClass([delegate class]));
    }
}

//  添加订阅
- (void)addTopic:(NSString *)topic {
    if (topic) {
        if (![self.topicArray containsObject:topic]) {
            [self.mqttSession subscribeToTopic:topic atLevel:(MQTTQosLevelAtLeastOnce)];
            [self.topicArray addObject:topic];
            NSLog(@"-----------------MQTT成功订阅 %@-----------------",topic);
        }
    }
}


// 删除订阅
- (void)delTopic:(NSString *)topic {
    if (topic) {
        if ([self.topicArray containsObject:topic]) {
            [self.mqttSession unsubscribeTopics:@[topic]];
            [self.topicArray removeObject:topic];
            NSLog(@"-----------------MQTT删除单个订阅 %@-----------------",topic);
        }
    }
}

// 清除订阅
- (void)clearTopic {
    if (self.topicArray.count > 0) {
        [self.mqttSession unsubscribeTopics:self.topicArray];
        [self.topicArray removeAllObjects];
        NSLog(@"-----------------MQTT清除所有订阅-----------------");
    }
    

}




#pragma mark -- 懒加载
-(MQTTSession *)mqttSession {
    
    if (!_mqttSession) {
        _mqttSession=[[MQTTSession alloc] init];
        _mqttSession.clientId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    }
    return _mqttSession;
}

-(MQTTCFSocketTransport *)transport {
    
    if (!_transport) {
        _transport=[[MQTTCFSocketTransport alloc] init];
    }
    return _transport;
}


- (NSHashTable<id<XMX_MQTTDelegate>> *)delegates {
    
    if (!_delegates) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return _delegates;
}


- (NSMutableArray *)topicArray {
    if (_topicArray == nil) {
        _topicArray = [NSMutableArray array];
    }
    return _topicArray;
}
@end
