#
#  Be sure to run `pod spec lint customview.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "customview"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of customview."
  spec.description  = <<-DESC
                   DESC
  spec.homepage     = "https://github.com/YYXuelangwang/customViewOrCategoryForUse.git"
  spec.license      = "MIT"
  spec.author             = { "yinyong" => "yy_xuelangwang@sina.com" }
  spec.platform     = :ios
  spec.source       = { :git => "https://github.com/YYXuelangwang/customViewOrCategoryForUse.git", :tag => "#{spec.version}" }
  spec.source_files  =  "XRDTitleBtnScrollView.{h,m}"
  spec.exclude_files = "Classes/Exclude"




end