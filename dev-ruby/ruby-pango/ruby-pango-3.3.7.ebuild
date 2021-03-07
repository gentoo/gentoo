# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Pango bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND+=" >=x11-libs/pango-1.2.1"
RDEPEND+=" >=x11-libs/pango-1.2.1"

ruby_add_rdepend "
	~dev-ruby/ruby-cairo-gobject-${PV}
	~dev-ruby/ruby-gobject-introspection-${PV}
"

all_ruby_prepare() {
	# Remove test depending on specific locales to be set up: bug 526248
	rm -f test/test-language.rb || die

	# Avoid native installer
	sed -i -e '/native-package-installer/ s:^:#: ; /^\s*setup_homebrew/ s:^:#:' ../glib2/lib/mkmf-gnome2.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_test() {
	# Include pango path since run-test does not list it
	${RUBY} -Iext/pango test/run-test.rb || die
}
