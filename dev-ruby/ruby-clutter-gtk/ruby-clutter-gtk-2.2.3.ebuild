# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-clutter-gtk/ruby-clutter-gtk-2.2.3.ebuild,v 1.6 2015/08/03 13:48:35 ago Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Clutter bindings"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RUBY_S=ruby-gnome2-all-${PV}/clutter-gtk

DEPEND+=" media-libs/clutter-gtk"
RDEPEND+=" media-libs/clutter-gtk"

ruby_add_bdepend ">=dev-ruby/ruby-glib2-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-clutter-${PV}
	>=dev-ruby/ruby-gtk3-${PV}"

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_install() {
	each_fakegem_install
}
