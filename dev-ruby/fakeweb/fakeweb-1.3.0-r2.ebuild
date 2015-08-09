# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ruby22 -> not compatible with new net/http implementation
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_DOCDIR="html"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Helper for faking web requests in Ruby"
HOMEPAGE="http://github.com/chrisk/fakeweb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "
	test? (
		dev-ruby/mocha:0.14
		dev-ruby/test-unit
		dev-ruby/samuel
		dev-ruby/right_http_connection
	)"

all_ruby_prepare() {
	# The package bundles samuel and right_http_connection, remove
	# them and use the packages instead.
	rm -r test/vendor || die "failed to remove bundled gems"

	# We don't package sdoc and we don't have the direct template.
	sed -i -e 's/sdoc/rdoc/' -e '/template/d' Rakefile || die

	# Require an old enough version of mocha
	sed -i -e '1igem "mocha", "~> 0.14.0"' test/test_helper.rb || die

	# Use the test-unit gem to make jruby compatible with newer mocha.
	sed -i -e '1igem "test-unit"' test/test_helper.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*ruby2[01])
			# Tests fail on mocking of TCPSocket, but fakeweb itself
			# actually works as evidenced by the thor test suite.
			rm test/test_fake_web_open_uri.rb test/test_allow_net_connect.rb test/test_fake_web.rb || die
			;;
	esac
}
