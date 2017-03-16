# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_NAME="gdk_pixbuf2"

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome2-all-${PV}/${RUBY_FAKEGEM_NAME}

DESCRIPTION="Ruby GdkPixbuf2 bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" x11-libs/gtk+:2"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}"

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}

each_ruby_install() {
	each_fakegem_install
}

