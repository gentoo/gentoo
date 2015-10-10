# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="test"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem eutils

DESCRIPTION="HTTP/REST API client library with pluggable components"
HOMEPAGE="https://github.com/lostisland/faraday"
SRC_URI="https://github.com/lostisland/faraday/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND+=" test? ( sys-process/lsof )"

ruby_add_rdepend ">=dev-ruby/multipart-post-1.2.0 <dev-ruby/multipart-post-3"
ruby_add_bdepend "test? (
		>=dev-ruby/test-unit-2.4
		dev-ruby/httpclient
		dev-ruby/rack-test
		dev-ruby/sinatra
		dev-ruby/net-http-persistent
		dev-ruby/patron
	)"

all_ruby_prepare() {
	# Remove bundler support.
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile test/helper.rb || die
	sed -i -e '/bundler/,/^fi/ s:^:#:' script/test || die

	# Remove simplecov and coveralls support, not needed to run tests.
	sed -i -e '/simplecov/,/^  end/ s:^:#:' test/helper.rb || die

	# Remove tests for adapters that are not packaged for Gentoo.
	rm test/adapters/em_http_test.rb test/adapters/em_synchrony_test.rb test/adapters/excon_test.rb test/adapters/typhoeus_test.rb || die

	# The proxy server is already killed, may be OS X vs Linux issue.
	sed -i -e '138 s/^/#/' script/test || die

	sed -i -e '/git ls-files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_prepare() {
	# Make sure the test scripts use the right ruby interpreter
	sed -i -e 's:ruby:'${RUBY}':' script/* || die
}

each_ruby_test() {
	each_fakegem_test

	# Sleep some time to allow the sinatra test server to die
	einfo "Waiting for test server to stop"
	sleep 10
}
