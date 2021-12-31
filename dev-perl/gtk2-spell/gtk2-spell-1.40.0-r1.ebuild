# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=Gtk2-Spell
MODULE_AUTHOR=TSCH
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Bindings for GtkSpell with Gtk2.x"
HOMEPAGE="http://gtk2-perl.sf.net/ https://metacpan.org/release/Gtk2-Spell"

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
