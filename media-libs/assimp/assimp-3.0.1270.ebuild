# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils versionator

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="http://assimp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}--${PV}-source-only.zip"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="+boost samples static tools"
SLOT="0"

DEPEND="
	boost? ( dev-libs/boost )
	samples? ( x11-libs/libX11 virtual/opengl media-libs/freeglut )
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}--${PV}-source-only

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build samples ASSIMP_SAMPLES) \
		$(cmake-utils_use_build tools ASSIMP_TOOLS) \
		$(cmake-utils_use_build static STATIC_LIB) \
		$(cmake-utils_use_enable !boost BOOST_WORKAROUND)
	)

	cmake-utils_src_configure
}
