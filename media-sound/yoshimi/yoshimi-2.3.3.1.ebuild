# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Software synthesizer based on ZynAddSubFX"
HOMEPAGE="https://yoshimi.github.io/"
SRC_URI="https://github.com/${PN^}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="+lv2"

BDEPEND="virtual/pkgconfig"
DEPEND="
	dev-libs/mxml:0
	media-libs/alsa-lib
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

DOCS=( ../Changelog ../README.txt )

src_prepare() {
	cmake_src_prepare
	sed -e "/^install.*doc.*DATAROOTDIR/s/${PN}/${PF}/" -i CMakeLists.txt || die
	append-cxxflags -lpthread
	append-cppflags -lpthread
}

src_configure() {
	local mycmakeargs=(
		-DLV2Plugin=$(usex lv2)
	)
	cmake_src_configure
}
