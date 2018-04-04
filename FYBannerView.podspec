#
# Be sure to run `pod lib lint FYBannerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FYBannerView'
  s.version          = '1.2.0'
  s.summary          = 'A short description of FYBannerView.'

  s.description      = <<-DESC
    使用CollectionView制作的轮播图, 已更新到swift4.0
                       DESC

  s.homepage         = 'https://github.com/wufeiyue/FYBannerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'eppeo' => 'ieppeo@163.com' }
  s.source           = { :git => 'https://github.com/wufeiyue/FYBannerView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'FYBannerView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FYBannerView' => ['FYBannerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Kingfisher'
end
