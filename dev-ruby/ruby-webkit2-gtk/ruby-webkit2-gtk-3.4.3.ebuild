# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby WebKitGtk+ for Gtk 3.0 bindings"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND+=" net-libs/webkit-gtk:4[introspection]"
RDEPEND+=" net-libs/webkit-gtk:4[introspection]"

ruby_add_rdepend "~dev-ruby/ruby-gobject-introspection-${PV}
	~dev-ruby/ruby-gtk3-${PV}"

each_ruby_test() {
	DCONF_PROFILE="${T}" virtx ${RUBY} test/run-test.rb
}
