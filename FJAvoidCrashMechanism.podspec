Pod::Spec.new do |s|
  s.name         = "FJAvoidCrashMechanism"
  s.version      = "0.0.1"
  s.summary      = "通过runtime,来防止数组、字典、字符串引起的崩溃"
  s.homepage     = "http://www.jianshu.com/p/bea2bfed3f3f"
 s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'fangjinfeng' => '116418179@qq.com' }
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/fangjinfeng/FJ_Safe.git", :tag => "0.0.1" }
  s.source_files  = "FJAvoidCrashMechanism", "*.{h,m}"
  s.requires_arc = true
  s.framework  = 'UIKit'
end
