# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby binding of gio-2"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" dev-libs/glib
	test? ( sys-apps/dbus )"
RDEPEND+=" dev-libs/glib"
ruby_add_rdepend "~dev-ruby/ruby-glib2-${PV}
	~dev-ruby/ruby-gobject-introspection-${PV}"

each_ruby_test() {
	XDG_RUNTIME_DIR=${T} dbus-launch ${RUBY} test/run-test.rb || die
}
