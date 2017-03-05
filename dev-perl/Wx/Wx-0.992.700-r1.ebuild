# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WX_GTK_VER="3.0"
MODULE_AUTHOR=MDOOTSON
MODULE_VERSION=0.9927
inherit wxwidgets virtualx perl-module

DESCRIPTION="Perl bindings for wxGTK"
HOMEPAGE="http://wxperl.sourceforge.net/ ${HOMEPAGE}"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Alien-wxWidgets-0.670.0
	x11-libs/wxGTK:${WX_GTK_VER}
	>=virtual/perl-File-Spec-0.820.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	>=virtual/perl-ExtUtils-ParseXS-3.150.0
	>=dev-perl/ExtUtils-XSpp-0.160.200
	>=virtual/perl-if-0.30.0
	test? (
		>=virtual/perl-Test-Harness-2.260.0
		>=virtual/perl-Test-Simple-0.430.0
	)
"

src_prepare() {
	need-wxwidgets base-unicode
	perl-module_src_prepare
}

src_test() {
	VIRTUALX_COMMAND=perl-module_src_test
	virtualmake
}

SRC_TEST=skip
# bug 571470
