Pod::Spec.new do |s|
s.name             = "CircleSlider"
s.version          = "0.2.3"
s.summary          = "CircleSlider is a Circular slider library. written in pure swift."
s.homepage         = "https://github.com/lampi87/CircleSlider.git"
s.license          = 'MIT'
s.source           = { :git => "https://github.com/lampi87/CircleSlider.git", :tag => s.version.to_s }
s.author           = { "shushutochako" => "shushutochako22@gmail.com" }
s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files = 'Pod/Classes/**/*'
end
