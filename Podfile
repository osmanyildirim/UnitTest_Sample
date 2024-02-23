# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'UnitTest_Sample' do
  use_frameworks!

  target 'UnitTest_SampleTests' do
    inherit! :search_paths
    pod 'OHHTTPStubs/Swift'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "13.0"
    end
  end
end
