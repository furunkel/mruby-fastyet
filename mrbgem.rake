MRuby::Gem::Specification.new('mruby-fastyet') do |spec|
  spec.license = 'MIT'
  spec.author  = 'furunkel'
  spec.bins = %w(fastyet)

  spec.add_dependency 'mruby-io', github: 'iij/mruby-io'
  spec.add_dependency 'mruby-dir', github: 'iij/mruby-dir'
end
