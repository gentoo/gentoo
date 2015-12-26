# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER=3.0
MODULE_AUTHOR=MDOOTSON
MODULE_VERSION=0.67
inherit wxwidgets perl-module

DESCRIPTION="Building, finding and using wxWidgets binaries"

SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE="gstreamer test"

RDEPEND="
	>=x11-libs/wxGTK-3:3.0[X,tiff,gstreamer=]
	>=dev-perl/Module-Pluggable-2.600.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-CBuilder-0.24
	>=virtual/perl-File-Spec-1.500.0
	>=dev-perl/Module-Build-0.280.0
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do"

src_configure() {
	myconf=( --wxWidgets-build=0 )
	perl-module_src_configure
}
