# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Software synthesizer based on ZynAddSubFX"
HOMEPAGE="https://yoshimi.github.io/"
SRC_URI="https://github.com/${PN^}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lv2"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-libs/mxml-2.5
	>=media-libs/alsa-lib-1.0.17
	media-libs/fontconfig
	media-libs/libsndfile
	sci-libs/fftw:3.0=
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	sys-libs/zlib
	virtual/jack
	x11-libs/cairo[X]
	x11-libs/fltk:1[opengl]
	lv2? ( media-libs/lv2 )
"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${WORKDIR}/${P}/src"

PATCHES=( "${FILESDIR}"/${P}-cxxflags.patch )

DOCS=( Changelog README.txt )

src_prepare() {
	cmake_src_prepare
	# respect doc dir
	sed -e "s#/doc/yoshimi#/doc/${PF}#" -i src/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DLV2Plugin=$(usex lv2)
	)
	cmake_src_configure
}
