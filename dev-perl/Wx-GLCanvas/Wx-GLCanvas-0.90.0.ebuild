# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MBARBON
DIST_VERSION=0.09
inherit perl-module virtualx

DESCRIPTION="interface to wxWidgets' OpenGL canvas"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="
	dev-perl/OpenGL
	dev-perl/Alien-wxWidgets[opengl]
	>=dev-perl/Wx-0.570.0
"
DEPEND="${RDEPEND}
	virtual/perl-Exporter
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	perl_rm_files "t/zz_pod.t"
	virtx perl-module_src_test
}
