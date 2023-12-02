# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
DIST_AUTHOR=MDOOTSON
DIST_VERSION=0.69
inherit wxwidgets perl-module

DESCRIPTION="Building, finding and using wxWidgets binaries"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~riscv ~x86"
IUSE="gstreamer opengl test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=x11-libs/wxGTK-3:${WX_GTK_VER}[gstreamer=,opengl=,tiff,X]
	>=dev-perl/Module-Pluggable-2.600.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-CBuilder-0.24
	>=virtual/perl-File-Spec-1.500.0
	>=dev-perl/Module-Build-0.280.0
	test? ( virtual/perl-Test-Simple )
"
DEPEND=${BDEPEND}

src_configure() {
	setup-wxwidgets
	myconf=( --wxWidgets-build=0 )
	perl-module_src_configure
}

src_test() {
	perl_rm_files t/zz_pod.t t/zy_pod_coverage.t
	perl-module_src_test
}
