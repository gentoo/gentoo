# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MBARBON
DIST_VERSION=0.09
WX_GTK_VER="3.2-gtk3"
inherit perl-module virtualx toolchain-funcs wxwidgets

DESCRIPTION="interface to wxWidgets' OpenGL canvas"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	dev-perl/OpenGL
	dev-perl/Alien-wxWidgets[opengl]
	>=dev-perl/Wx-0.570.0
"
BDEPEND="${RDEPEND}
	virtual/perl-Exporter
	virtual/perl-ExtUtils-MakeMaker
"

src_configure() {
	# use c++ compiler
	export CC="$(tc-getCXX)"
	export CXX="$(tc-getCXX)"
	setup-wxwidgets
	perl-module_src_configure
}

src_test() {
	perl_rm_files "t/zz_pod.t"
	virtx perl-module_src_test
}
