# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_GEMSPEC="gio2.gemspec"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby binding of gio-2"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE="test"

DEPEND="dev-libs/glib
	test? ( sys-apps/dbus )"
RDEPEND="dev-libs/glib"
ruby_add_rdepend "
	dev-ruby/fiddle
	~dev-ruby/ruby-glib2-${PV}
	~dev-ruby/ruby-gobject-introspection-${PV}
"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	ruby-ng-gnome2_all_ruby_prepare

	# Avoid test requiring network access
	rm -f test/test-resolver.rb || die
}

each_ruby_test() {
	XDG_RUNTIME_DIR=${T} dbus-launch ${RUBY} test/run-test.rb || die
}
