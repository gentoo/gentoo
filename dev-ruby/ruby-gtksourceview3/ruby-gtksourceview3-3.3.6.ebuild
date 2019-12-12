# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby Gtk3 bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" x11-libs/gtksourceview:3.0"
RDEPEND+=" x11-libs/gtksourceview:3.0"

ruby_add_bdepend ">=dev-ruby/ruby-glib2-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-gtk3-${PV}"

all_ruby_prepare() {
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
