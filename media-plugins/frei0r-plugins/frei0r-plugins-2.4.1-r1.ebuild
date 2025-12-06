# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"
inherit cmake-multilib docs

DESCRIPTION="A minimalistic plugin API for video effects"
HOMEPAGE="https://www.dyne.org/software/frei0r/"
SRC_URI="https://github.com/dyne/frei0r/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/frei0r-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ppc ~ppc64 ~riscv x86"
IUSE="doc +facedetect +scale0tilt"

RDEPEND="x11-libs/cairo[${MULTILIB_USEDEP}]
	facedetect? ( >=media-libs/opencv-2.3.0:=[contrib,contribdnn,features2d,ffmpeg,${MULTILIB_USEDEP}] )
	scale0tilt? ( >=media-libs/gavl-1.2.0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"

DOCS=( AUTHORS.md README.md )

src_prepare() {
	cmake_src_prepare

	# https://bugs.gentoo.org/418243
	sed -i \
		-e '/set.*CMAKE_C_FLAGS/s:"): ${CMAKE_C_FLAGS}&:' \
		src/filter/*/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_OPENCV=$(usex !facedetect)
		-DWITHOUT_GAVL=$(usex !scale0tilt)
	)
	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile
	use doc && docs_compile
}
