# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ZHMYLOVE
DIST_VERSION=0.21
inherit perl-module virtualx

DESCRIPTION="Perl bindings for libxcb"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-perl/Data-Dump
	dev-perl/Mouse
	dev-perl/MouseX-NativeTraits
	dev-perl/Try-Tiny
	dev-perl/XML-Descent
	dev-perl/XML-Simple
	>=virtual/perl-XSLoader-0.20.0
	>=x11-libs/libxcb-1.2
	x11-libs/xcb-util
	x11-libs/xcb-util-wm
"
DEPEND="
	>=x11-libs/libxcb-1.2
	x11-libs/xcb-util
	x11-libs/xcb-util-wm
	x11-base/xcb-proto
"
BDEPEND="
	${RDEPEND}
	x11-base/xcb-proto
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

src_test() {
	virtx perl-module_src_test
}
