# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools flag-o-matic versionator

MY_PV="$(get_version_component_range 1-3)$(get_version_component_range 4)"
MY_PV=${MY_PV/p/}

DESCRIPTION="Host software for controlling the RepRap open source 3D printer"
HOMEPAGE="https://github.com/timschmidt/repsnapper"
SRC_URI="https://github.com/timschmidt/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	epatch "${FILESDIR}/std-c11.patch"
	epatch "${FILESDIR}/${P}-gcc6.patch"
	eautoreconf
	append-cxxflags -std=c++11
}
