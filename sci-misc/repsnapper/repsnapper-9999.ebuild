# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools git-r3

DESCRIPTION="Host software for controlling the RepRap open source 3D printer"
HOMEPAGE="https://github.com/timschmidt/repsnapper"
EGIT_REPO_URI="https://github.com/timschmidt/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-cpp/gtkglextmm-1.2
	dev-cpp/gtkmm:2.4
	dev-cpp/libxmlpp:2.6
	dev-libs/libzip
	virtual/opengl
"
RDEPEND=${DEPEND}

src_prepare() {
	eautoreconf
	append-cxxflags -std=c++11
}
