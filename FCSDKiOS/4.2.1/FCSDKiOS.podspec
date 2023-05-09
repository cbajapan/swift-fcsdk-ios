Pod::Spec.new do |s|
s.name              = 'FCSDKiOS'
s.version           = '4.2.1'
s.summary           = 'FCSDKiOS XCFramework'
s.homepage          = 'https://github.com/cbajapan/swift-fcsdk-ios'

s.author            = { 'Name' => 'Communication Business Avenue, Inc.' }
s.license           = { :type => 'Commercial', :text => 'Copyright Communication Business Avenue, Inc. Use of this software is subject to the terms and conditions located at https://github.com/cbajapan/swift-fcsdk-ios/blob/main/License.txt'}

s.source            = { :http => 'https://swift-sdk.s3.us-east-2.amazonaws.com/client_sdk/FCSDKiOS-4.2.1.xcframework.zip' }

s.platforms = { :ios => "11.0" }

s.vendored_frameworks = 'FCSDKiOS.xcframework'
end
