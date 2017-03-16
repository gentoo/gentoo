# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby Gtk3 bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" x11-libs/gtk+:3"
RDEPEND+=" x11-libs/gtk+:3"

ruby_add_bdepend ">=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-pango-${PV}"

ruby_add_rdepend "
	>=dev-ruby/ruby-atk-${PV}
	>=dev-ruby/ruby-gdk3-${PV}
	>=dev-ruby/ruby-gdkpixbuf2-${PV}
	>=dev-ruby/ruby-gio2-${PV}
	>=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-gobject-introspection-${PV}
	>=dev-ruby/ruby-pango-${PV}
"

all_ruby_prepare() {
	# Avoid compilation of dependencies during test.
	sed -i -e '/which make/,/^    end/ s:^:#:' test/run-test.rb || die

	# Use standard icon
	sed -i -e 's/"find"/"call-start"/' test/test-gtk-icon-theme.rb || die
	sed -i -e 's/"search"/"system-search"/' test/test-gtk-icon-theme.rb || die
}

each_ruby_test() {
	VIRTUALX_COMMAND=${RUBY}
	 virtualmake test/run-test.rb || die
}
