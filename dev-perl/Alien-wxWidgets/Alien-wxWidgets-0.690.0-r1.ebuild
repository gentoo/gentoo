# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER=3.0
DIST_AUTHOR=MDOOTSON
DIST_VERSION=0.69
inherit wxwidgets perl-module

DESCRIPTION="Building, finding and using wxWidgets binaries"

SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE="gstreamer opengl test"

RDEPEND="
	>=x11-libs/wxGTK-3:3.0[gstreamer=,opengl=,tiff,X]
	>=dev-perl/Module-Pluggable-2.600.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-CBuilder-0.24
	>=virtual/perl-File-Spec-1.500.0
	>=dev-perl/Module-Build-0.280.0
	test? ( virtual/perl-Test-Simple )
"

src_configure() {
	setup-wxwidgets
	myconf=( --wxWidgets-build=0 )
	perl-module_src_configure
}

src_test() {
	perl_rm_files t/zz_pod.t t/zy_pod_coverage.t
	perl-module_src_test
}
