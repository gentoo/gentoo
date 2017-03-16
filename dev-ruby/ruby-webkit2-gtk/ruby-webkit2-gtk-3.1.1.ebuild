# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby WebKitGtk+ for Gtk 3.0 bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" net-libs/webkit-gtk:4"
RDEPEND+=" net-libs/webkit-gtk:4"

RUBY_S="ruby-gnome2-all-${PV}/webkit2-gtk"

ruby_add_rdepend ">=dev-ruby/ruby-gobject-introspection-${PV}
	>=dev-ruby/ruby-gtk3-${PV}"

all_ruby_prepare() {
	# Avoid unneeded dependency on test-unit-notify.
	sed -i -e '/notify/ s:^:#:' \
		../gobject-introspection/test/gobject-introspection-test-utils.rb \
		test/webkit2-gtk-test-utils.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/"Makefile"/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_test() {
	VIRTUALX_COMMAND="${RUBY}"
	DCONF_PROFILE="${T}" virtualmake test/run-test.rb || die
}

each_ruby_install() {
	each_fakegem_install
}
