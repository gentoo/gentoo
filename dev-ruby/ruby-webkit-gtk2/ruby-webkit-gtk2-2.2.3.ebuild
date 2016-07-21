# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby WebKitGtk+ for Gtk 2.0 bindings"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND+=" net-libs/webkit-gtk:2"
RDEPEND+=" net-libs/webkit-gtk:2"

RUBY_S="ruby-gnome2-all-${PV}/webkit-gtk2"

ruby_add_bdepend ">=dev-ruby/ruby-glib2-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-gobject-introspection-${PV}
	>=dev-ruby/ruby-gtk2-${PV}"

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_install() {
	each_fakegem_install
}
