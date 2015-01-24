Pod::Spec.new do |s|
  s.name         = 'JBSSettings'
  s.version      = '0.1.0'
  s.summary      = 'A settings object that is less annoying than NSUserDefaults'
  s.description  = ''
  s.homepage     = 'https://github.com/jsumners/JBSSettings'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'James Sumners' => "james.sumners@gmail.com" }
  s.source       = { :git => 'https://github.com/jsumners/JBSSettings.git', :tag => s.version.to_s }

  #s.ios.deployment_target = '4.0'
  s.osx.deployment_target = '10.10'

  s.requires_arc = true

  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
end
