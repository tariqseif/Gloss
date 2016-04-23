Pod::Spec.new do |s|
  s.name             = "Gloss"
  s.version          = "0.7.2"
  s.summary          = "A shiny JSON parsing library in Swift"
  s.description      = "A shiny JSON parsing library in Swift. Features include mapping JSON to objects, mapping objects to JSON, handling of nested objects and custom transformations."
  s.homepage         = "https://github.com/hkellaway/Gloss"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Harlan Kellaway" => "hello@harlankellaway.com" }
  s.social_media_url = "http://twitter.com/HarlanKellaway"
  s.source           = { :git => "https://github.com/hkellaway/Gloss.git", :tag => s.version.to_s }
  
  s.platforms     = { :ios => "8.0", :osx => "10.9", :tvos => "9.0", :watchos => "2.0" }
  s.requires_arc = true

  s.default_subspec   = 'Gloss'

  s.subspec 'Gloss' do |ss|
      ss.dependency     'Gloss/Core'
  end

  s.subspec 'Core' do |ss|
      ss.source_files = 'Sources/*.swift'
  end

  s.subspec 'Networking' do |ss|
      ss.dependency     'Gloss/Core'
      ss.source_files = 'Sources/Networking/*.swift'
  end

  s.subspec 'Alamofire' do |ss|
      ss.dependency     'Gloss/Networking'
      ss.dependency     'Alamofire', '~> 3.0'
      ss.source_files = 'Sources/Networking/Alamofire/*.swift' 
  end

end