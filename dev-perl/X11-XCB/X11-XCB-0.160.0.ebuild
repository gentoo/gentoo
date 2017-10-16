# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSTPLBG
DIST_VERSION=0.16
inherit perl-module virtualx

DESCRIPTION="Perl bindings for libxcb"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Data-Dump
	dev-perl/Mouse
	dev-perl/MouseX-NativeTraits
	dev-perl/Try-Tiny
	dev-perl/XML-Descent
	dev-perl/XML-Simple
	>=virtual/perl-XSLoader-0.20.0
	x11-proto/xcb-proto
	>=x11-libs/libxcb-1.2
	x11-libs/xcb-util
	x11-libs/xcb-util-wm
"
DEPEND="${RDEPEND}
	>=virtual/perl-Devel-PPPort-3.190.0
	dev-perl/ExtUtils-Depends
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=virtual/perl-ExtUtils-ParseXS-3.180.0
	dev-perl/ExtUtils-PkgConfig
	dev-perl/XS-Object-Magic
	test? (
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
PATCHES=( "${FILESDIR}/${P}-526.patch" )
src_compile() {
	MAKEOPTS="-j1" perl-module_src_compile
}
src_test() {
	virtx perl-module_src_test
}
