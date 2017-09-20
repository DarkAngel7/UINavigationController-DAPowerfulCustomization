#
#  Be sure to run `pod spec lint UINavigationController+DAPowerfulCustomization.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "UINavigationController+DAPowerfulCustomization"
  s.version      = "1.3.1"
  s.summary      = "You can customization UINavigationBar for each view controller and enjoy your life."
  s.description  = <<-DESC
                  A category to expand UINavigationController
 
                  1. Enable interactive pop gesture.
                  2. You can easily custom the navigation bar and status bar appearance in different view controllers, the appearance transition when push or pop will be wonderful.
                  3. When user click the default back button on navigation bar, you can handle the click event and you can prevent the pop event by returning NO.
                  4. You can handle the interactive pop gesture recognizer event, returning no to prevent it began.
 
                  Enjoy it.
                   DESC

  s.homepage     = "https://github.com/DarkAngel7/UINavigationController-DAPowerfulCustomization"
  s.license      = "MIT"
  s.author             = "DarkAngel"
  s.social_media_url   = "http://weibo.com/darkangel7"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DarkAngel7/UINavigationController-DAPowerfulCustomization.git", :tag => "#{s.version}" }
  s.source_files  = "UINavigationController+DAPowerfulCustomization/", "UINavigationController+DAPowerfulCustomization/**/*.{h,m}"
  s.public_header_files = 'UINavigationController+DAPowerfulCustomization/UINavigationController+DAPowerfulCustomization.h'
  s.framework  = "UIKit"
  s.requires_arc = true
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/objc" }

end
