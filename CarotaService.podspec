Pod::Spec.new do |s|
  s.name             = 'CarotaService'
  s.version          = '1.1.3'
  s.summary          = 'A Network Service provider to supply MarketPlanner App.'

  s.description      = <<-DESC
  CarotaService is a framework to serve MarketPlanner, all the requests should be
  handled by this module
                       DESC

  s.homepage         = 'https://github.com/Carota-MarketPlanner/ios-carota-service.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Elias Ferreira' => 'eliasferreira.pro@gmail.com' }
  s.source           = { :git => 'https://github.com/Carota-MarketPlanner/ios-carota-service.git', :tag => s.version.to_s }

  s.platforms = { :ios => '15.0' }
  s.ios.deployment_target = '15.0'
    
  s.pod_target_xcconfig = { "ENABLE_BITECODE" => "NO", "SKIP_INSTALL" => "NO" }

  s.default_subspecs = "Binary"

  s.subspec 'Binary' do |release|
    release.vendored_frameworks = 'Release/CarotaService.xcframework'
  end

  s.subspec 'Source' do |debug|
    debug.source_files = 'CarotaService/Classes/**/*'
  end
  
end
