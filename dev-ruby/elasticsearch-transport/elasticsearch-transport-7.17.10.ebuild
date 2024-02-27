# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

MY_P=elasticsearch-ruby-${PV}
DESCRIPTION="Ruby integrations for ES, elasticsearch-transport module"
HOMEPAGE="https://github.com/elastic/elasticsearch-ruby"
SRC_URI="https://github.com/elastic/elasticsearch-ruby/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	|| ( dev-ruby/faraday:2 dev-ruby/faraday:1 )
	dev-ruby/multi_json
"
ruby_add_bdepend "
	doc? ( dev-ruby/yard )
	test? (
		dev-ruby/ansi
		dev-ruby/mocha:1.0
		dev-ruby/pry
		dev-ruby/rspec:3
		dev-ruby/shoulda-context
		dev-ruby/curb
		dev-ruby/ethon
	)
"

RUBY_S=${MY_P}/${PN}

all_ruby_prepare() {
	# fix to work without git
	sed -i -e 's/git ls-files/find * -type f/' *.gemspec || die

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

	# Avoid specs that require a running elasticsearch instance or
	# unpackaged Faraday adapter.
	sed -e '/#perform_request/ s/describe/xdescribe/' \
		-e '/when the client connects/ s/context/xcontext/' \
		-e '/when using the \(HTTPClient\|Patron\) adapter/ s/context/xcontext/' \
		-e '/require.*\(httpclient\|patron\)/ s:^:#:' \
		-e '/when the adapter is \(patron\|specified as a string key\|typhoeus\)/ s/context/xcontext/' \
		-e '/when the adapter can be detected/ s/context/xcontext/' \
		-e '/when the Faraday adapter is configured/ s/context/xcontext/' \
		-i spec/elasticsearch/transport/client_spec.rb || die
	sed -e '/using \(httpclient\|typhoeus\|patron\)/ s/context/xcontext/' \
		-e '/require.*httpclient/ s:^:#:' \
		-i spec/elasticsearch/transport/meta_header_spec.rb || die
	sed -e '/retries on 404 status the specified number of max_retries/ s/it/xit/' \
		-i spec/elasticsearch/transport/base_spec.rb || die
}
