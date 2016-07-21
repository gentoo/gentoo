# Autoload rubygems as with regular Ruby.
begin
require 'rubygems'
rescue LoadError
end

# Append regular site_ruby to $LOAD_PATH. Unfortunately the -I option prepends instead.
$LOAD_PATH.insert(-2, '/usr/lib/ruby/site_ruby/1.8', '/usr/lib/ruby/site_ruby')
