# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby Gtk2 bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" x11-libs/gtk+:2
	x11-themes/hicolor-icon-theme"
RDEPEND+=" x11-libs/gtk+:2"

ruby_add_bdepend ">=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-pango-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-gdkpixbuf2-${PV}
	>=dev-ruby/ruby-atk-${PV}
	>=dev-ruby/ruby-pango-${PV}"

all_ruby_prepare() {
	# Avoid compilation of dependencies during test.
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die

	# Use standard icon
	sed -i -e 's/"find"/"call-start"/' test/test_gtk_icon_theme.rb || die

	# Fix search path for gtk-2.0 on Gentoo
	sed -i -e "/include_paths =/ s:]$:,'/usr/include/gtk-2.0']:" ext/gtk2/extconf.rb || die
}

each_ruby_test() {
	VIRTUALX_COMMAND=${RUBY}
	virtualmake test/run-test.rb || die
}
