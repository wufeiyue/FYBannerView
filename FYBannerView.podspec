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
  s.summary          = '使用UICollectionView实现的swift轮播图FYBannerView, 留给开发者扩展很强'

  s.description      = <<-DESC
    使用CollectionView制作的轮播图, 已更新到swift4.0
  1. 带有动画效果的pageControl，可自定义pageControl元素之间的间距/大小/位置
  2. 可自定义文字标题的字体大小/颜色/内边距
  3. 有两种风格的文字标题遮罩背景（渐变色背景/半透明背景）
  4. 文字轮播
  5. 动态改变数据源，可以实时更新轮播图显示内容
                       DESC

  s.homepage         = 'https://github.com/wufeiyue/FYBannerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'eppeo' => 'ieppeo@163.com' }
  s.source           = { :git => 'https://github.com/wufeiyue/FYBannerView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'FYBannerView/Classes/**/*'
  
  s.dependency 'Kingfisher'
end
