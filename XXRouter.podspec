Pod::Spec.new do |s|
s.name         = 'XXRouter'
s.version      = '0.0.4'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.homepage     = 'https://github.com/ShawnCow/XXRouter'
s.authors      = {'大黄' => 'rockhxy@gmail.com'}
s.summary      = '简单的路由管理  router'

s.platform     =  :ios, '7.0'
s.source       =  {:git => 'https://github.com/ShawnCow/XXRouter.git', :tag => s.version}
s.source_files =  'XXRouter/*.{h,m}'
s.frameworks   =  'Foundation','UIKit'

s.requires_arc = true

end
