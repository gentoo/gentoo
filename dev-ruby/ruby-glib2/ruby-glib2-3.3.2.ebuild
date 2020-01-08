# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""
RDEPEND+=" >=dev-libs/glib-2"
DEPEND+=" >=dev-libs/glib-2"

ruby_add_bdepend "dev-ruby/pkg-config
	test? ( >=dev-ruby/test-unit-2 )"

all_ruby_prepare() {
	# Skip spawn tests since our sandbox also provides items in the environment and this makes the test fragile.
	rm -f test/test-spawn.rb || die

	# Remove pregenerated Makefile since it will otherwise be shared by all targets.
	rm -f Makefile Makefile.lib ext/glib2/Makefile || die

	# Avoid native installer
	sed -i -e '/native-package-installer/ s:^:#:' lib/mkmf-gnome2.rb || die
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
