source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
use_frameworks!

def default_pods
  pod 'ReactorKit', '~> 3.0'
  pod 'Then'
  rx_pods
  network_pods
end

def rx_pods
  pod 'RxSwift', '~> 6.1.0'
  pod 'RxCocoa', '~> 6.1.0'
  pod 'RxDataSources', '~> 5.0'
end

def network_pods
  pod 'Moya/RxSwift', :git => 'https://github.com/Moya/Moya.git', :branch => 'development'
  pod 'Kingfisher'
end

def test_pods
  pod 'RxExpect', :git => 'https://github.com/SH-OH/RxExpect.git', :branch => 'develop'
end

target 'Github-SHOH' do
    default_pods
end

target 'Github-SHOHTests' do
    inherit! :search_paths
    default_pods
    test_pods
end

target 'Github-SHOHUITests' do
    test_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end