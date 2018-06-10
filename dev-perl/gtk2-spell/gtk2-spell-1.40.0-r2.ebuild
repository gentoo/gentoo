# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_NAME=Gtk2-Spell
DIST_AUTHOR=TSCH
DIST_VERSION=1.04
inherit perl-module virtualx

DESCRIPTION="Bindings for GtkSpell with Gtk2.x"
HOMEPAGE="http://gtk2-perl.sf.net/ ${HOMEPAGE}"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~hppa ~ppc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	>=app-text/gtkspell-2:2
	>=dev-perl/glib-perl-1.240.0
	>=dev-perl/Gtk2-1.012
"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/ExtUtils-PkgConfig
	virtual/pkgconfig
"
src_test() {
	virtx perl-module_src_test
}
