# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_NAME=Gtk2-TrayManager
DIST_AUTHOR=BORUP
DIST_VERSION=0.05
DIST_EXAMPLES=("examples/*")
inherit perl-module virtualx

DESCRIPTION="Perl bindings for EggTrayManager"
HOMEPAGE="http://gtk2-perl.sf.net/ https://metacpan.org/release/Gtk2-TrayManager"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="amd64 ~ia64 x86"

RDEPEND="
	x11-libs/gtk+:2
	>=dev-perl/glib-perl-1.012
	>=dev-perl/Gtk2-1.012
"
BDEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/ExtUtils-PkgConfig
	dev-util/glib-utils
	virtual/pkgconfig
"

src_test() {
	virtx perl-module_src_test
}
