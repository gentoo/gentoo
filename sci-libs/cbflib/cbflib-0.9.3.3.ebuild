# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake-utils eutils flag-o-matic fortran-2 toolchain-funcs

MY_P1="CBFlib-${PV}"
#MY_P2="CBFlib_${PV}"
MY_P2="CBFlib_0.9.3"

DESCRIPTION="Library providing a simple mechanism for accessing CBF files and imgCIF files"
HOMEPAGE="http://www.bernstein-plus-sons.com/software/CBF/"
BASE_TEST_URI="http://arcib.dowling.edu/software/CBFlib/downloads/version_${PV}/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P1}.tar.gz"
#	test? (
#		mirror://sourceforge/${PN}/${MY_P2}_Data_Files_Input.tar.gz
#		mirror://sourceforge/${PN}/${MY_P2}_Data_Files_Output.tar.gz
#	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

S=${WORKDIR}/${MY_P1}

RDEPEND="sci-libs/hdf5:="
DEPEND="${RDEPEND}"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-unbundle.patch
)

src_prepare(){
	rm -rf Py* drel* dRel* ply* || die

	append-fflags -fno-range-check

	tc-export CC CXX AR RANLIB FC F77
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUNPACKED_DIRECTORY="${S}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dosym ${PN} /usr/include/cbf
}
