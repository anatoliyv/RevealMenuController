#
# Be sure to run `pod lib lint RevealMenuController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RevealMenuController'
  s.version          = '0.1.0'
  s.summary          = 'Menu controller with expandable item groups, custom position and appearance animation written with Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Menu controller with expandable item groups, custom position and appearance animation written with Swift.
Similar to AuctionSheet style of UIAlertController.
                       DESC

  s.homepage         = 'https://github.com/anatoliyv/RevealMenuController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anatoliy Voropay' => 'anatoliy.voropay@gmail.com' }
  s.source           = { :git => 'https://github.com/anatoliyv/RevealMenuController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/anatoliy_v'

  s.ios.deployment_target = '8.0'

  s.source_files = 'RevealMenuController/Classes/**/*'

  # s.resource_bundles = {
  #   'RevealMenuController' => ['RevealMenuController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'SMIconLabel', '~> 0.1.0'
end
