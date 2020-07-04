# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="HTTP/REST API client library with pluggable components"
HOMEPAGE="https://github.com/lostisland/faraday"
SRC_URI="https://github.com/lostisland/faraday/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND+=" test? ( sys-process/lsof )"

ruby_add_rdepend ">=dev-ruby/multipart-post-1.2.0 <dev-ruby/multipart-post-3"
ruby_add_bdepend "test? (
		>=dev-ruby/test-unit-2.4
		>=dev-ruby/connection_pool-2.2.2
		|| ( dev-ruby/rack:2.0 dev-ruby/rack:1.6 )
	)"

all_ruby_prepare() {
	# Remove bundler support.
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d ; 1irequire "yaml"' Rakefile || die
	sed -i -e '/bundler/,/^fi/ s:^:#:' script/test || die
	# Avoid loading all lib files since some of them require unpackaged dependencies.
	sed -e '/[Cc]overall/ s:^:#:' \
		-e '/lib\/\*\*/ s:^:#:' \
		-e '3igem "rack", "<2.1"' \
		-i spec/spec_helper.rb || die

	# The proxy server is already killed, may be OS X vs Linux issue.
	#sed -i -e '138 s/^/#/' script/test || die

	sed -i -e '/git ls-files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid multipart tests that require an unpackaged dependency
	# that appears to be no longer maintained.
	rm -f spec/faraday/request/multipart_spec.rb || die
	sed -e '/multipart_parser/ s:^:#:' \
		-i spec/support/helper_methods.rb || die

	# Remove specs for unpackaged adapters
	rm -f spec/faraday/adapter/{em_http,em_synchrony,excon}_spec.rb || die

	# Make this adapter optional since it comes with a long list of
	# dependencies.
	if ! has_version "dev-ruby/typhoeus:1" ; then
		rm -f  spec/faraday/adapter/typhoeus_spec.rb || die
	fi
}

each_ruby_prepare() {
	# Make sure the test scripts use the right ruby interpreter
	sed -i -e 's:ruby:'${RUBY}':' script/* || die
}

each_ruby_test() {
	MT_NO_PLUGINS=true each_fakegem_test

	# Sleep some time to allow the sinatra test server to die
	einfo "Waiting for test server to stop"
	sleep 10
}
