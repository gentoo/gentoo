# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=POTYL
DIST_VERSION=0.05
DIST_EXAMPLES=( "examples/*" )
inherit perl-module virtualx

DESCRIPTION="Perl binding for C libunique library"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/libunique:1
	dev-perl/Gtk2
"
DEPEND="${RDEPEND}
	dev-perl/glib-perl
	dev-perl/ExtUtils-Depends
	dev-perl/ExtUtils-PkgConfig
"

PATCHES=( "${FILESDIR}"/${PN}-0.05-implicit-pointer.patch )

src_test() {
	virtx perl-module_src_test
}
