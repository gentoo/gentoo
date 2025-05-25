# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Pango bindings"
KEYWORDS="amd64 ~ppc ~riscv ~x86"
DEPEND="dev-libs/glib
	>=x11-libs/pango-1.14.0[introspection]"
RDEPEND="dev-libs/glib
	>=x11-libs/pango-1.14.0[introspection]"

ruby_add_rdepend "
	~dev-ruby/ruby-cairo-gobject-${PV}
	~dev-ruby/ruby-glib2-${PV}
	~dev-ruby/ruby-gobject-introspection-${PV}
"

all_ruby_prepare() {
	ruby-ng-gnome2_all_ruby_prepare

	# Remove test depending on specific locales to be set up: bug 526248
	rm -f test/test-language.rb || die
}

each_ruby_test() {
	# Include pango path since run-test does not list it
	${RUBY} -Iext/pango test/run-test.rb || die
}
