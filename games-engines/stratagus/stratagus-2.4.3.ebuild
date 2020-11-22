# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="A realtime strategy game engine"
HOMEPAGE="https://wargus.github.io/stratagus.html
	https://github.com/Wargus/stratagus"
SRC_URI="https://github.com/Wargus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 debug doc fluidsynth mikmod mng theora vorbis"
REQUIRED_USE="theora? ( vorbis )"

RDEPEND="
	dev-db/sqlite:3
	>=dev-lang/lua-5:0
	dev-lua/toluapp
	media-libs/libpng:0
	virtual/opengl
	x11-libs/libX11
	media-libs/libsdl[sound,opengl,video]
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	fluidsynth? ( media-sound/fluidsynth )
	mikmod? ( media-libs/libmikmod )
	mng? ( media-libs/libmng )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
		theora? ( media-libs/libtheora )
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${PN}"-2.3.0-doc.patch
)

src_prepare() {
	sed -i -e 's:-Werror::' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	# there are in-source switches
	use debug && CMAKE_BUILD_TYPE=Debug

	local mycmakeargs=(
		-DGAMEDIR="/usr/bin"
		-DDOCDIR="/usr/share/doc/${PF}"
		-DWITH_BZIP2=$(usex bzip2)
		-DWITH_FLUIDSYNTH=$(usex fluidsynth)
		-DWITH_MIKMOD=$(usex mikmod)
		-DWITH_MNG=$(usex mng)
		-DWITH_OGGVORBIS=$(usex vorbis)
		-DWITH_THEORA=$(usex theora)
		-DENABLE_DOC=$(usex doc)
		-DENABLE_DEV=ON
	)

	cmake_src_configure
}
