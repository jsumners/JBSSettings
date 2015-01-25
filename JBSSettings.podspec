Pod::Spec.new do |s|
  s.name         = 'JBSSettings'
  s.version      = '0.1.1'
  s.summary      = 'A settings object that is less annoying than NSUserDefaults'
  s.description  = ''
  s.homepage     = 'https://github.com/jsumners/JBSSettings'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'James Sumners' => "james.sumners@gmail.com" }
  s.source       = {
                      :git => 'https://github.com/jsumners/JBSSettings.git',
                      :tag => 'v'+s.version.to_s
                   }

  #s.ios.deployment_target = '4.0'
  s.osx.deployment_target = '10.10'

  # Yes, it requires ARC, but it also depends on a library that doesn't.
  # `pod spec lint` can't handle that. Good times!
  #s.requires_arc = true
  s.dependency 'FMDB', '~> 2.5'

  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
end
