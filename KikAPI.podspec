#
# Be sure to run `pod lib lint KikAPI.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "KikAPI"
  s.version          = "1.0.0"
  s.summary          = "Native API for interacting with the Kik Messenger client."
  s.homepage         = "https://github.com/kikinteractive/kik-api-iphone"
  s.license          = 'Apache2'
  s.author           = { "Kik Interactive" => "dev@kik.com" }
  s.source           = { :git => "https://github.com/kikinteractive/kik-api-iphone.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kik'
  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets/*.png'
  s.frameworks = 'UIKit', 'StoreKit', 'CoreGraphics', 'MobileCoreServices'
  s.dependency 'UIImage-ResizeMagick'
end
