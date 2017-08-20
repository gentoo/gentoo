# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=Gtk2-TrayManager
MODULE_AUTHOR=BORUP
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Perl bindings for EggTrayManager"
HOMEPAGE="http://gtk2-perl.sf.net/ ${HOMEPAGE}"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="amd64 ia64 ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=dev-perl/glib-perl-1.012
	>=dev-perl/Gtk2-1.012"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/ExtUtils-PkgConfig
	virtual/pkgconfig"
