# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

COMMIT=48208f9bf053577befe5723746b6ff35b99b45d0

inherit ruby-fakegem

DESCRIPTION="Helper for faking web requests in Ruby"
HOMEPAGE="https://github.com/chrisk/fakeweb"
SRC_URI="https://github.com/chrisk/fakeweb/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RUBY_PATCHES=( fakeweb-ruby22.patch
	fakeweb-ruby23.patch )

ruby_add_bdepend "
	test? (
		dev-ruby/mocha:0.14
		dev-ruby/test-unit
	)"

all_ruby_prepare() {
	# The package bundles samuel and right_http_connection, remove
	# them
	rm -r test/vendor || die "failed to remove bundled gems"

	# We don't package sdoc and we don't have the direct template.
	sed -i -e 's/sdoc/rdoc/' -e '/template/d' Rakefile || die

	# Require an old enough version of mocha
	sed -i -e '1igem "mocha", "~> 0.14.0"' test/test_helper.rb || die

	# Use the test-unit gem to make jruby compatible with newer mocha.
	sed -i -e '1igem "test-unit"' \
		-e '/bundler/I s:^:#:' \
		-e '/simplecov/ s:^:#:' test/test_helper.rb || die

	# Avoid test dependencies on unmaintained packages that no longer work
	rm test/test_other_net_http_libraries.rb || die

	sed -i -e '/test:preflight/ s:^:#:' Rakefile || die
}
