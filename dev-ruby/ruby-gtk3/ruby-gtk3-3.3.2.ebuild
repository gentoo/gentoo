# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby Gtk3 bindings"
KEYWORDS="amd64 ~ppc ~x86"
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
	>=dev-ruby/ruby-pango-${PV}
"

all_ruby_prepare() {
	# Avoid native installer
	sed -i -e '/native-package-installer/ s:^:#: ; /^\s*setup_homebrew_libffi/ s:^:#:' ../glib2/lib/mkmf-gnome2.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/which make/,/^    end/ s:^:#:' test/run-test.rb || die

	# Use standard icon
	sed -i -e 's/"find"/"call-start"/' test/test-gtk-icon-theme.rb || die
	sed -i -e 's/"search"/"system-search"/' test/test-gtk-icon-theme.rb || die
}

each_ruby_test() {
	virtx ${RUBY} test/run-test.rb
}
