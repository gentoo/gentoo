# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_NAME="gtksourceview2"

inherit virtualx ruby-ng-gnome2

RUBY_S=ruby-gnome2-all-${PV}/gtksourceview2

DESCRIPTION="Ruby bindings for gtksourceview"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" x11-libs/gtksourceview:2.0"
DEPEND+=" x11-libs/gtksourceview:2.0"

ruby_add_rdepend ">=dev-ruby/ruby-gtk2-${PV}"

all_ruby_prepare() {
	# Avoid native installer
	sed -i -e '/native-package-installer/ s:^:#: ; /^\s*setup_homebrew/ s:^:#:' ../glib2/lib/mkmf-gnome2.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_test() {
	virtx ${RUBY} test/run-test.rb
}
