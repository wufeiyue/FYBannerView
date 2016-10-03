id
d::Spec.new do |s|

  s.name         = "FYSliderView"
  s.version      = "1.0.0"
  s.summary      = "Swift轮播图，基于UICollectionView完成，使用Kingfisher做好图片异步缓存库，可定制性比较强"
  s.homepage     = "http://www.wufeiyue.com/"
  s.license      = "MIT"
  s.author       = { "武飞跃" => "75731531@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/eppeo/FYSliderView.git", :tag => "1.0.0" }
  s.source_files  = "FYSliderView", "*"
  s.requires_arc = true
  s.dependency "Kingfisher", "~> 2.6.0"

  end

