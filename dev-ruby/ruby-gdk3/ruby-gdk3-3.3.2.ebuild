# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby GDK-3.x bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" x11-libs/gtk+:3"
RDEPEND+=" x11-libs/gtk+:3"

ruby_add_rdepend "
	~dev-ruby/ruby-gdkpixbuf2-${PV}
	~dev-ruby/ruby-cairo-gobject-${PV}
	~dev-ruby/ruby-pango-${PV}
"

all_ruby_prepare() {
	# Avoid unneeded dependency on test-unit-notify.
	sed -i -e '/notify/ s:^:#:' \
		test/gdk-test-utils.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/Makefile/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_test() {
	virtx ${RUBY} test/run-test.rb
}

each_ruby_install() {
	each_fakegem_install
}
