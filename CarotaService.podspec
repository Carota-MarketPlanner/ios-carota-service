Pod::Spec.new do |s|
  s.name             = 'CarotaService'
  s.version          = '1.0.1'
  s.summary          = 'A Network Service provider to supply MarketPlanner App.'

  s.description      = <<-DESC
  CarotaService is a framework to serve MarketPlanner, all the requests should be
  handled by this module
                       DESC

  s.homepage         = 'https://github.com/Carota-MarketPlanner/ios-carota-service'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Elias Ferreira' => 'eliasferreira.pro@gmail.com' }
  s.source           = { :git => 'https://github.com/Carota-MarketPlanner/ios-carota-service', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.default_subspecs = "Binary"

  s.subspec 'Binary' do |binary|
    binary.vendored_frameworks = 'CarotaService.framework'
  end

  # s.subspec 'Source' do |source|
  #   s.source_files = 'CarotaService/Classes/**/*'
  # end
  
end
