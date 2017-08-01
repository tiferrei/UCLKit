Pod::Spec.new do |s|
  s.name             = "UCLKit"
  s.version          = "0.1.0"
  s.summary          = "UCL API wrapper in Swift"
  s.description      = <<-DESC
						UCL API wrapper in Swift.
                        Not maintained by UCL.
                        DESC
  s.homepage         = "https://github.com/tiferrei/UCLKit"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Tiago Ferreira" => "me@tiferrei.com" }
  s.source           = { :git => "https://github.com/tiferrei/UCLKit.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/tiferrei2000"
  s.module_name     = "UCLKit"
  s.dependency "NBNRequestKit", "~> 2.0.2"
  s.requires_arc = true
  s.source_files = "UCLKit/*.swift"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.1'
  s.tvos.deployment_target = '9.0'
end
