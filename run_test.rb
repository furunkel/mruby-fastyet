#!/usr/bin/env ruby
#
# mrbgems test runner
#

if __FILE__ == $0
  #repository, dir, branch = 'https://github.com/mruby/mruby.git', 'tmp/mruby', 'master'
  repository, dir, branch = 'https://github.com/furunkel/mruby.git', 'tmp/mruby', 'jit'
  build_args = ARGV

  Dir.mkdir 'tmp'  unless File.exist?('tmp')
  unless File.exist?(dir)
    system "git clone --depth 1 --branch #{branch} #{repository} #{dir}"
  end

  exit system(%Q[cd #{dir}; MRUBY_CONFIG=#{File.expand_path __FILE__} ruby minirake -v #{build_args.join(' ')}])
end

MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'

  enable_debug

  conf.gem github: 'ksss/mruby-file-stat'
  conf.gem github: 'iij/mruby-dir'
  conf.gem File.expand_path(File.dirname(__FILE__))
end
