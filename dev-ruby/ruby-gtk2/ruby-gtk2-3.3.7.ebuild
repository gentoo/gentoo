# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby Gtk2 bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" x11-libs/gtk+:2
	x11-themes/hicolor-icon-theme"
RDEPEND+=" x11-libs/gtk+:2"

ruby_add_rdepend "
	>=dev-ruby/ruby-gdkpixbuf2-${PV}
	>=dev-ruby/ruby-atk-${PV}
	>=dev-ruby/ruby-pango-${PV}"

all_ruby_prepare() {
	# Avoid native installer
	sed -i -e '/native-package-installer/ s:^:#: ; /^\s*setup_homebrew/ s:^:#:' ../glib2/lib/mkmf-gnome2.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die

	# Use standard icon
	sed -i -e 's/"find"/"call-start"/' test/test_gtk_icon_theme.rb || die

	# Fix search path for gtk-2.0 on Gentoo
	sed -i -e "/include_paths =/ s:]$:,'/usr/include/gtk-2.0']:" ext/gtk2/extconf.rb || die
}

each_ruby_test() {
	virtx ${RUBY} test/run-test.rb
}
