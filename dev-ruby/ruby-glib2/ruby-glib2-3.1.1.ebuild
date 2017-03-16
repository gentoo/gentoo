# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
RDEPEND+=" >=dev-libs/glib-2"
DEPEND+=" >=dev-libs/glib-2"

ruby_add_bdepend "dev-ruby/pkg-config
	test? ( >=dev-ruby/test-unit-2 )"

all_ruby_prepare() {
	# Skip spawn tests since our sandbox also provides items in the environment and this makes the test fragile.
	rm -f test/test_spawn.rb || die

	# Remove pregenerated Makefile since it will otherwise be shared by all targets.
	rm -f Makefile Makefile.lib ext/glib2/Makefile || die
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
