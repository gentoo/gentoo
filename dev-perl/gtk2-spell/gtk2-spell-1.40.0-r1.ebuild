# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=Gtk2-Spell
MODULE_AUTHOR=TSCH
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Bindings for GtkSpell with Gtk2.x"
HOMEPAGE="http://gtk2-perl.sf.net/ ${HOMEPAGE}"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 hppa ~ppc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	>=app-text/gtkspell-2:2
	>=dev-perl/glib-perl-1.240.0
	>=dev-perl/gtk2-perl-1.012
"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/extutils-pkgconfig
	virtual/pkgconfig
"
