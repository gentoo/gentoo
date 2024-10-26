# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Transport classes and utilities shared among Ruby Elastic client libraries"
HOMEPAGE="https://github.com/elastic/elastic-transport-ruby"
SRC_URI="https://github.com/elastic/elastic-transport-ruby/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="elastic-transport-ruby-${PV}"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="doc test"

ruby_add_rdepend "
	|| ( dev-ruby/faraday:2 dev-ruby/faraday:1 )
	dev-ruby/multi_json
"
ruby_add_bdepend "
	doc? ( dev-ruby/yard )
	test? (
		dev-ruby/ansi
		dev-ruby/hashie
		|| ( ( dev-ruby/faraday:2 dev-ruby/faraday-net_http_persistent:2 ) dev-ruby/faraday:1 )
		dev-ruby/mocha:2
		dev-ruby/pry
		dev-ruby/rspec:3
		dev-ruby/shoulda-context
		dev-ruby/curb
	)
"

all_ruby_prepare() {
	# fix to work without git
	sed -i -e 's/git ls-files/find * -type f/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# remove useless dependencies from Rakefile
	sed -e '/bundler/d' \
		-e '/require.*cane/,/end/d' \
		-i Rakefile || die

	# Tweak test setup to only run unit tests since we don't have a live cluster
	sed -e "s/RUBY_VERSION > '1.9'/false/" \
		-e '/module Elasticsearch/,$ s:^:#:' \
		-e '/reporters/ s:^:#: ; /Reporters::SpecReporter/,/^end/ s:^:#: ; /Reporters.use/ s:^:#:' \
		-i test/test_helper.rb || die

	sed -e '/pry/ s:^:#:' \
		-e '/config.formatter/ s:^:#:' \
		-i spec/spec_helper.rb || die

	# Avoid specs that require a running elasticsearch instance
	sed -e '/#perform_request/ s/describe/xdescribe/' \
		-e '/when the client connects/ s/context/xcontext/' \
		-i spec/elastic/transport/client_spec.rb || die
	sed -e '/retries on 404 status the specified number of max_retries/ s/it/xit/' \
		-i spec/elastic/transport/base_spec.rb || die

	# Avoid specs that require unpackaged gems
	sed -e '/when using the HTTPClient adapter/ s/context/xcontext/' \
		-e '/require.*httpclient/ s:^:#:' \
		-e '/when the adapter is \(patron\|typhoeus\)/ s/context/xcontext/' \
		-e '/require.*\(patron\|typhoeus\)/ s:^:#:' \
		-e '/when the adapter \(can be detected\|is specified as a string key\)/ s/context/xcontext/' \
		-e '/when the Faraday adapter is \(configured\|set in the block\)/ s/context/xcontext/' \
		-i spec/elastic/transport/client_spec.rb || die
	sed -e '/using \(httpclient\|patron\|typhoeus\)/ s/context/xcontext/' \
		-i spec/elastic/transport/meta_header_spec.rb || die
}
