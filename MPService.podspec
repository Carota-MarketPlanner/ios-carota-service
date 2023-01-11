Pod::Spec.new do |s|
  s.name             = 'MPService'
  s.version          = '0.1.0'
  s.summary          = 'A Network Service provider to supply MarketPlanner App.'

  s.description      = <<-DESC
  Service is a framework to serve MarketPlanner, all the requests should be
  handled by this module
                       DESC

  s.homepage         = 'https://github.com/MarketPlanner/ios-mp-service'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Elias Ferreira' => 'eliasferreira.pro@gmail.com' }
  s.source           = { :git => 'https://github.com/MarketPlanner/ios-mp-service', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.source_files = 'MPService/Classes/**/*'
  
  # s.dependency 'AFNetworking', '~> 2.3'
end
