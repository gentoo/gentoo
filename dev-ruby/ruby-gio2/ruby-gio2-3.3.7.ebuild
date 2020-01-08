# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby binding of GooCanvas"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-gobject-introspection-${PV}"

all_ruby_prepare() {
	# Avoid native installer
	sed -i -e '/native-package-installer/ s:^:#: ; /^\s*setup_homebrew/ s:^:#:' ../glib2/lib/mkmf-gnome2.rb || die

	# Avoid unneeded dependency on test-unit-notify.
	sed -i -e '/notify/ s:^:#:' \
		test/gio2-test-utils.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/which make/,/^  end/ s:^:#:' test/run-test.rb || die

	# Make sure Makefile is generated fresh for each target
	rm -f ext/gio2/Makefile Makefile Makefile.lib || die
}

each_ruby_test() {
	XDG_RUNTIME_DIR=${T} dbus-launch ${RUBY} test/run-test.rb || die
}
