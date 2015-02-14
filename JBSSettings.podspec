Pod::Spec.new do |s|
  s.name         = 'JBSSettings'
  s.version      = '0.1.2'
  s.summary      = 'A settings object that is less annoying than NSUserDefaults'
  s.description  = 'A settings object that is less annoying than NSUserDefaults.'
  s.homepage     = 'https://github.com/jsumners/JBSSettings'
  s.license      = { :type => 'MIT' }
  s.authors      = { 'James Sumners' => "james.sumners@gmail.com" }
  s.source       = {
                      :git => 'https://github.com/jsumners/JBSSettings.git',
                      :tag => 'v'+s.version.to_s
                   }

  #s.ios.deployment_target = '4.0'
  s.osx.deployment_target = '10.10'

  s.dependency 'FMDB', '~> 2.5'

  s.source_files = 'Classes/JBSSettings.{h,m}',
                   'Classes/MAObjCRuntime/M*.{h,m}',
                   'Classes/MAObjCRuntime/RT*.{h,m}'
  s.exclude_files = 'Classes/MAObjCRuntime/main.m'
  s.requires_arc = ['Classes/JBSSettings.m']
end
