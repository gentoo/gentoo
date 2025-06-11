# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="changelog.txt README.md"
RUBY_FAKEGEM_GEMSPEC="excon.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="EXtended http(s) CONnections"
HOMEPAGE="https://github.com/excon/excon"
SRC_URI="https://github.com/excon/excon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

ruby_add_rdepend "dev-ruby/logger"

ruby_add_bdepend "
	dev-ruby/rake
	test? (
		dev-ruby/activesupport
		>=dev-ruby/json-1.8.5
		dev-ruby/open4
		>=dev-ruby/rack-2.2.7-r1
		dev-ruby/rackup
		dev-ruby/rdoc
		dev-ruby/sinatra
		dev-ruby/webrick
	)
"
all_ruby_prepare() {
	sed -i -e 's/git ls-files --/find */' ${RUBY_FAKEGEM_GEMSPEC} || die

	# test that need network
	rm -f spec/excon/test/server_spec.rb || die

	# test that wrongly assumes 127.0.0.1 won't run a DNS server
	rm -f spec/requests/{dns_timeout,resolv_resolver}_spec.rb || die

	# tests that depend on eventmachine which is broken and no longer maintained
	rm -f tests/{bad,error,pipeline,response,request}_tests.rb \
		tests/{batch-requests,complete_responses}.rb \
		tests/middlewares/{decompress,mock}_tests.rb  || die
	rm -f spec/requests/eof_requests_spec.rb spec/excon/error_spec.rb || die
}
