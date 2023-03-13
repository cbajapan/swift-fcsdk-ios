Pod::Spec.new do |s|
s.name              = 'WebRTC'
s.version           = '110.0.0'
s.summary           = 'WebRTC XCFramework'
s.homepage          = 'https://github.com/cbajapan/swift-fcsdk-ios'

s.author            = { 'Name' => 'Communication Business Avenue, Inc.' }
s.license           = { :type => 'Commercial', :text => 'Copyright Communication Business Avenue, Inc. Use of this software is subject to the terms and conditions located at https://github.com/cbajapan/swift-fcsdk-ios/blob/main/Open-Source%20Licenses/WebRTC.txt' }

s.source            = { :http => 'https://swift-sdk.s3.us-east-2.amazonaws.com/real_time/WebRTC-m110.xcframework.zip' }

s.platforms = { :ios => "13.0" }

s.vendored_frameworks = 'WebRTC.xcframework'
end
