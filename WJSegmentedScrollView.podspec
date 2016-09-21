
Pod::Spec.new do |s|

  s.name         = "WJSegmentedScrollView"
  s.version      = "0.0.1"
  s.summary      = "segment scrollview."

  s.description  = <<-DESC
                   segment scrollview
                   DESC

  s.homepage     = "https://github.com/shengmingzz/WJSegmentedScrollView"
  s.author = { 'td705' => 'ryds4321@sohu.com' }
  # s.social_media_url   = "http://twitter.com/"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"

  s.source       = { :git => "https://github.com/shengmingzz/WJSegmentedScrollView.git", :tag => "#{s.version}" }

  s.platform = :ios, '7.0'
  s.source_files = 'Pod/Classes/**/*'
  s.requires_arc = true

  s.dependency 'Masonry', '~>0.6.1'
  s.dependency 'HMSegmentedControl', '~> 1.5.2'
end
