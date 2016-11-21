# Kenichi Kamiya 2016
#   cat script/data/2016-11-15-ruby-2-3-2-released.md | ruby script/update-ruby.rb
#   cat script/data/2016-11-21-ruby-2-3-3-released.md | ruby script/update-ruby.rb


require 'digest/md5'

release_post = STDIN.read

file = nil
ruby_ver = nil
dict = {}
release_post.each_line do |line|
  case line
  when %r!\* \[https://cache.ruby-lang.org/pub/ruby/2\.\d/((ruby-2\.\d\.\d).\S+)\]\(https://cache.ruby-lang.org/pub/ruby/2\.\d/ruby-2\.\d\.\d.\S+\)!
    file = $1
    ruby_ver = $2
    dict[file] = {}
  when /\s*(SHA\d+):\s*(\S+)/
    dict[file][$1] = $2
  when /## Release Comment/
    # require 'pp'
    # pp dict # For debug
  else
  end
end

FORMATS = %w[tar.bz2 tar.gz tar.xz zip].freeze

puts "checksum.md5"
FORMATS.each do |ext|
  filename = "#{ruby_ver}.#{ext}"
  puts [Digest::MD5.file("script/data/#{filename}").hexdigest, filename].join('  ')
end

%w[SHA1 SHA256 SHA512].each do |sha_ver|
  puts "checksum.#{sha_ver.downcase}"
  FORMATS.each do |ext|
    filename = "#{ruby_ver}.#{ext}"
    release_post = dict[filename][sha_ver]
    mine = Digest.const_get(sha_ver).file("script/data/#{filename}").hexdigest

    raise "given an invalid data" unless release_post == mine

    puts [release_post, filename].join('  ')
  end
end
