Pod::Spec.new do |s|
  s.name             = 'CarotaService'
  s.version          = '1.2.2'
  s.summary          = 'A Network Service provider to supply MarketPlanner App.'

  s.description      = <<-DESC
  CarotaService is a framework to serve MarketPlanner, all the requests should be
  handled by this module
                       DESC

  s.homepage         = 'https://github.com/Carota-MarketPlanner/ios-carota-service.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Elias Ferreira' => 'eliasferreira.pro@gmail.com' }
  s.source           = { :http => "https://github.com/Carota-MarketPlanner/ios-carota-service/releases/download/#{s.version}/CarotaService-#{s.version}.zip" }

  s.platforms = { :ios => '15.0' }

  s.ios.deployment_target = '15.0'

  s.vendored_frameworks = 'CarotaService.xcframework'
  s.source_files = 'CarotaService/Classes/**/*'
  
end
