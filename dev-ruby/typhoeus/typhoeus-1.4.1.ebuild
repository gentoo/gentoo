# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md UPGRADE.md"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Runs HTTP requests in parallel while cleanly encapsulating handling logic"
HOMEPAGE="https://rubygems.org/gems/typhoeus/
	https://github.com/typhoeus/typhoeus"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

# Tests fail with ethon-0.16.0
# https://github.com/typhoeus/typhoeus/issues/710
ruby_add_rdepend "<dev-ruby/ethon-0.16.0"

ruby_add_bdepend "test? (
	dev-ruby/json
	dev-ruby/faraday:1
	dev-ruby/rack:2.2
	>=dev-ruby/sinatra-1.3
	>=dev-ruby/redis-3.0
	>=dev-ruby/dalli-2.7.9
)"

all_ruby_prepare() {
	sed -e '/bundler/I s:^:#:' -i Rakefile spec/spec_helper.rb || die
	sed -i -e '3igem "rack", "~> 2.2.0"; gem "faraday", "<2"; require "timeout"' spec/spec_helper.rb || die
	sed -i -e '/Rack::Handler::WEBrick/ s/options/\*\*options/' spec/support/localhost_server.rb || die

	# Avoid specs failing because default headers are provided or
	# checked now, probably due to changes in either rack or webrick.
	sed -e '/calls on_headers and on_\(body\|complete\)/ s/it/xit/' \
		-i spec/typhoeus/request/operations_spec.rb || die
}
