//
//  XMX_MQTTDelegate.h
//  MQTTClient
//
//  Created by Sierra on 2019/1/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XMX_MQTTDelegate <NSObject>
@optional

-(void)MQTT_didReceiveServerStatus:(NSDictionary *)status;

-(void)MQTT_messageTopic:(NSString *)topic messageDic:(NSDictionary *)messageDic;

-(void)MQTT_messageTopic:(NSString *)topic messageStr:(NSString *)messageStr;
@end

NS_ASSUME_NONNULL_END
