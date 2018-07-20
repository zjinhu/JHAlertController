 
Pod::Spec.new do |s|
  s.name             = 'JHAlertController'
  s.version          = '0.1.0'
  s.summary          = '封装系统UIAlertController，链式编程，一行代码弹窗.'
 
  s.description      = <<-DESC
							链式编程，一行代码弹窗.
                       DESC

  s.homepage         = 'https://github.com/jackiehu/' 
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HU' => '814030966@qq.com' }
  s.source           = { :git => 'https://github.com/jackiehu/JHAlertController.git', :tag => s.version.to_s }
 
  s.platform         = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source_files = 'JHAlertController/JHAlertController/Class/**/*.{h,m}'
  s.frameworks   = "UIKit", "Foundation" #支持的框架
  s.requires_arc        = true 
end
