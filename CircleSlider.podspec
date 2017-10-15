Pod::Spec.new do |s|
s.name             = "CircleSlider"
s.version          = "0.6.0"
s.summary          = "CircleSlider is a Circular slider library. written in pure swift."
s.homepage         = "https://github.com/shushutochako/CircleSlider"
s.license          = 'MIT'
s.author           = { "shushutochako" => "shushutochako22@gmail.com" }
s.source           = { :git => "https://github.com/shushutochako/CircleSlider.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/shushutochako'

s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files = 'Pod/Classes/**/*'
end
