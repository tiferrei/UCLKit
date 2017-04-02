Pod::Spec.new do |s|
  s.name             = "UCLKit"
  s.version          = "0.1.0"
  s.summary          = "UCL API communication in one line of code"
  s.description      = <<-DESC
                        UCLKit allows you to integrate the UCL API in Apple
						platform apps. Leave all the networking and parsing for
						UCLKit, focus on the app itself.

                        This is not maintained by UCL.
                        DESC
  s.homepage         = "https://gitlab.com/UCLAPI/UCLKit"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Tiago Ferreira" => "me@tiferrei.com" }
  s.source           = { :git => "https://gitlab.com/UCLAPI/UCLKit.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/tiferrei2000"
  s.module_name     = "UCLKit"
  s.dependency "NBNRequestKit", "~> 2.0"
  s.requires_arc = true
  s.source_files = "UCLKit/*.swift"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
end
