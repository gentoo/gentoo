# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

OB_CMAKE_PV="0.3.12"
OB_CMAKE_DIST_P="OBCMake-${OB_CMAKE_PV}"
OB_CMAKE_P="OBCmake-${OB_CMAKE_PV}"

DESCRIPTION="Library for compressing images with the DXT/S3TC standard"
HOMEPAGE="https://oblivioncth.github.io/libsquish/"
SRC_URI="
	https://github.com/oblivioncth/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/oblivioncth/OBCMake/archive/refs/tags/v${OB_CMAKE_PV}.tar.gz -> ${OB_CMAKE_DIST_P}.tar.gz
"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="openmp"

DOCS=( README.md )
PATCHES=(
	"${FILESDIR}/${P}-local-obcmake.patch"
)

src_unpack() {
	default
	mv "${WORKDIR}/${OB_CMAKE_P}" "${S}/.obcmake" || die
}

src_prepare() {
	default
	rm -r _old || die
	cmake_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_SKIP_RPATH=ON
		-DLIBSQUISH_DOCS=OFF
		-DLIBSQUISH_EXTRAS=OFF
		-DLIBSQUISH_TESTS=OFF
		-DLIBSQUISH_USE_ALTIVEC=OFF
		-DLIBSQUISH_USE_OPENMP=$(usex openmp)
		-DLIBSQUISH_USE_SSE2=ON
		-DNO_VERBOSE_VERSION=ON
		-DOB_CMAKE_SOURCE_DIR="${S}/.obcmake"
	)

	cmake_src_configure
}
