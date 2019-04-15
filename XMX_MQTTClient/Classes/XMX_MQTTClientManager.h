//
//  XMX_MQTTClientManager.h
//  MQTTClient
//
//  Created by Sierra on 2019/1/15.
//

#import <Foundation/Foundation.h>

#import "XMX_MQTTDelegate.h"

#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTLog.h>
NS_ASSUME_NONNULL_BEGIN

@interface XMX_MQTTClientManager : NSObject
/**
 单例
 
 @return self
 */
+(XMX_MQTTClientManager *)shareInstance;


/**
 登录MQTT
 
 - Authors: 谢茂雄
 - CopyRight: 版权信息
 - Date: 2019-1-15
 - Since: iOS 8.0
 - Version: 0.0.1
 

 @param ip ip
 @param port 端口
 @param userName 用户名
 @param password 密码
 @param cleanSessionFlag 是否清除session 用来获取离线消息
 @param isAutoConnect 是否自定重连
 @param autoConnectInterval 登录重连间隔
 @param LogLevel log等级
 

 
 @code
 
 [[XMX_MQTTClientManager shareInstance] loginWithIp:MQTT_brokerURL
                                        port:MQTT_port
                                        userName:MQTT_userName
                                        password:MQTT_password
                                        cleanSessionFlag:false
                                        isAutoConnect:true
                                        autoConnectInterval:60];
 
 
 
 */
-(void)loginWithIp:(NSString *)ip
              port:(UInt16)port
          userName:(NSString *)userName
          password:(NSString *)password
  cleanSessionFlag:(BOOL)cleanSessionFlag
     isAutoConnect:(BOOL)isAutoConnect
autoConnectInterval:(NSInteger)autoConnectInterval
        DDLogLevel:(DDLogLevel)LogLevel;


/**
 关闭MQTT
 */
-(void)close;


/**
 绑定delegate

 @param delegate 控制器
 */
- (void)bind:(id<XMX_MQTTDelegate>)delegate;


/**
 解绑delegate

 @param delegate 控制器
 */
- (void)unbind:(id<XMX_MQTTDelegate>)delegate;


/**
 添加订阅

 @param topic 订阅标签
 */
- (void)addTopic:(NSString *)topic;


/**
 删除订阅
 
 @param topic 订阅标签
 */
- (void)delTopic:(NSString *)topic;



/**
 清空订阅
 
 @param topic 订阅标签
 */
- (void)clearTopic;



- (void)sendTopic:(NSString *)topic parameter:(NSDictionary *)parameter;
@end

NS_ASSUME_NONNULL_END
