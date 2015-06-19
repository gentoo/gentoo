# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-clutter-gtk/ruby-clutter-gtk-2.0.2.ebuild,v 1.2 2014/08/17 10:19:25 blueness Exp $

EAPI=4
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Clutter bindings"
KEYWORDS="~amd64 ~ppc"
IUSE=""

RUBY_S=ruby-gnome2-all-${PV}/clutter-gtk

DEPEND="${DEPEND} media-libs/clutter-gtk"
RDEPEND="${RDEPEND} media-libs/clutter-gtk"

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
