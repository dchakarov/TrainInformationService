Pod::Spec.new do |s|
  s.name             = 'TrainInformationService'
  s.version          = '0.1.3'
  s.swift_version    = '4.2'
  s.summary          = 'Information services for trains in the UK, using the National Rail open API'
  s.description      = <<-DESC
The API is a stab at a friendlier interface for the National Rail Live Departure Boards Web Service - https://lite.realtime.nationalrail.co.uk/OpenLDBWS/
                       DESC

  s.homepage         = 'https://github.com/dchakarov/TrainInformationService'
  s.license          = { :type => 'Unlicense', :file => 'LICENSE' }
  s.author           = { 'Dimitar Chakarov' => 'dimitar@dchakarov.com' }
  s.source           = { :git => 'https://github.com/dchakarov/TrainInformationService.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gimly'

  s.ios.deployment_target = '11.0'
  s.source_files = 'Sources/TrainInformationService/**/*'

  s.dependency 'SWXMLHash'
end
