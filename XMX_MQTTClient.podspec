#
# Be sure to run `pod lib lint XMX_MQTTClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XMX_MQTTClient'
  s.version          = '0.1.1'
  s.summary          = 'MQTT工具类'

  s.description      = <<-DESC
                        MQTT的简单封装
                       DESC

  s.homepage         = 'https://github.com/736497373/XMX_MQTTClient'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '736497373' => '谢茂雄' }
  s.source           = { :git => 'https://github.com/736497373/XMX_MQTTClient', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

   s.source_files = 'XMX_MQTTClient/Classes/**/*'
   s.public_header_files = 'Pod/Classes/**/*.h'
   s.dependency 'MQTTClient'
end
