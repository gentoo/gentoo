# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Object-oriented 3D toolkit for rendering and interaction of chemical systems"
HOMEPAGE="http://www.tecn.upf.es/openMOIV/"
SRC_URI="http://www.tecn.upf.es/openMOIV/download/1.0.3/OpenMOIV.src.${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/coin"
DEPEND="${RDEPEND}"

S="${WORKDIR}/OpenMOIV.src.${PV/a//}"

src_prepare() {
	cmake-utils_src_prepare
	sed \
		-e 's:$ENV{OIV_DIR}/include:/usr/include/coin:g' \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-Dshared:int=1
		-Dcoin:int=1
		-Dsys_fonts:int=1
	)
	cmake-utils_src_configure
}

src_install() {
	dolib.so "${BUILD_DIR}"/libChemKit2.so

	insinto /usr/include
	doins -r "${S}"/include/ChemKit2
}
