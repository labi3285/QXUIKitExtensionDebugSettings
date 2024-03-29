Pod::Spec.new do |s|

s.name = "QXUIKitExtensionDebugSettings"
s.version = "0.1.0"
s.swift_version = "5.0"
s.summary = "A debug settings extension for change apis/settings in debug mode."
s.description = <<-DESC
A debug settings extension for change apis/settings in debug mode. Just enjoy!
DESC
s.homepage = "https://github.com/labi3285/QXUIKitExtensionDebugSettings"
s.license = "MIT"
s.author = { "labi3285" => "766043285@qq.com" }
s.platform = :ios, "9.0"
s.source = { :git => "https://github.com/labi3285/QXUIKitExtensionDebugSettings.git", :tag => "#{s.version}" }
s.source_files = "Project/QXDebugSettings/*"
s.requires_arc = true

s.dependency 'QXUIKitExtension'

# pod trunk push QXUIKitExtensionDebugSettings.podspec --allow-warnings

end

