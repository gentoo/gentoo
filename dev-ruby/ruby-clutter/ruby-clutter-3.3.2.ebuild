# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby Clutter bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

RUBY_S=ruby-gnome2-all-${PV}/clutter

DEPEND+=" media-libs/clutter"
RDEPEND+=" media-libs/clutter"

ruby_add_bdepend ">=dev-ruby/ruby-atk-${PV}
	>=dev-ruby/ruby-gdkpixbuf2-${PV}
	>=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-gobject-introspection-${PV}
	>=dev-ruby/ruby-pango-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-cairo-gobject-${PV}
	>=dev-ruby/ruby-gobject-introspection-${PV}
	>=dev-ruby/ruby-pango-${PV}"

all_ruby_prepare() {
	# Avoid unneeded dependency on test-unit-notify.
	sed -i -e '/notify/ s:^:#:' \
		../gobject-introspection/test/gobject-introspection-test-utils.rb \
		../cairo-gobject/test/cairo-gobject-test-utils.rb \
		test/clutter-test-utils.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die
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
