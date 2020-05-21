# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ruby26: not compatible
USE_RUBY="ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

COMMIT=2b08c1ff2714ec13a12f3497d67fcefce95c2cbe

inherit ruby-fakegem

DESCRIPTION="Helper for faking web requests in Ruby"
HOMEPAGE="https://github.com/chrisk/fakeweb"
SRC_URI="https://github.com/chrisk/fakeweb/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "
	test? (
		dev-ruby/mocha
		dev-ruby/test-unit
	)"

all_ruby_prepare() {
	# The package bundles samuel and right_http_connection, remove
	# them
	rm -r test/vendor || die "failed to remove bundled gems"

	# We don't package sdoc and we don't have the direct template.
	sed -i -e 's/sdoc/rdoc/' -e '/template/d' Rakefile || die

	# Use the test-unit gem to make jruby compatible with newer mocha.
	sed -i -e '1igem "test-unit"' \
		-e '/bundler/I s:^:#:' \
		-e '/simplecov/ s:^:#:' test/test_helper.rb || die

	# Avoid test dependencies on unmaintained packages that no longer work
	rm test/test_other_net_http_libraries.rb || die

	sed -i -e '/test:preflight/ s:^:#:' Rakefile || die

	# Avoid tests that require a network connection
	sed -i -e '/test_real_https_request/aomit "requires network"' test/test_fake_web.rb || die
}
