# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Artsy/Specs.git'

source 'http://repo.baichuan-ios.taobao.com/baichuanSDK/AliBCSpecs.git'
source 'http://repo.baichuan-ios.taobao.com/baichuanSDK/AliBCSpecsMirror.git'

platform :ios, '8.0'
use_frameworks!

pod "FFastlib"
# 阿里百川用户反馈
pod "YWFeedbackFMWK", "~> 2.0.3.1"
# UMeng统计
pod "UMengAnalytics", "~> 4.2.4"
# 远程参数后台
pod 'TLRemoteConfig', '~> 0.1.0'
# 新建窗口特效
pod 'iCarousel'
# webView进度条
pod 'NJKWebViewProgress','~>0.2.3'



target 'yd2browser' do

end

target 'yd2browserTests' do

end

target 'yd2browserUITests' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
