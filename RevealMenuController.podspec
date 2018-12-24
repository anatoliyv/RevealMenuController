Pod::Spec.new do |s|
  s.name             = 'RevealMenuController'
  s.version          = '0.4.0'
  s.summary          = 'Menu controller with expandable item groups, custom position and appearance animation written with Swift.'
  s.description      = <<-DESC
Menu controller with expandable item groups, custom position and appearance animation written with Swift.
Similar to AuctionSheet style of UIAlertController.
                       DESC
  s.homepage         = 'https://github.com/anatoliyv/RevealMenuController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anatoliy Voropay' => 'anatoliy.voropay@gmail.com' }
  s.source           = { :git => 'https://github.com/anatoliyv/RevealMenuController.git', :tag => "v.0.4.0" }
  s.social_media_url = 'https://twitter.com/anatoliy_v'
  s.ios.deployment_target = '9.0'
  s.source_files = 'RevealMenuController/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'SMIconLabel'
end
