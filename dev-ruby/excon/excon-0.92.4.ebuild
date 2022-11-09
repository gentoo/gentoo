# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="changelog.txt README.md"
RUBY_FAKEGEM_GEMSPEC="excon.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="EXtended http(s) CONnections"
HOMEPAGE="https://github.com/excon/excon"
SRC_URI="https://github.com/excon/excon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

ruby_add_bdepend "
	dev-ruby/rake
	test? (
		dev-ruby/activesupport
		>=dev-ruby/json-1.8.5
		dev-ruby/open4
		dev-ruby/rdoc
		dev-ruby/sinatra
	)
"
all_ruby_prepare() {
	sed -i -e 's/git ls-files --/find */' ${RUBY_FAKEGEM_GEMSPEC} || die

	# test that need network
	rm -f spec/excon/test/server_spec.rb || die

	# tests that depend on eventmachine which is broken and no longer maintained
	rm -f tests/{bad,error,pipeline,response,request}_tests.rb \
		tests/{batch-requests,complete_responses}.rb \
		tests/middlewares/{decompress,mock}_tests.rb  || die
	rm -f spec/requests/eof_requests_spec.rb spec/excon/error_spec.rb || die
}
