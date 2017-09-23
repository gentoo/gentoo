# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils eutils

DESCRIPTION="A realtime strategy game engine"
HOMEPAGE="https://launchpad.net/stratagus/"
SRC_URI="https://github.com/Wargus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 debug doc fluidsynth mikmod mng theora vorbis"

RDEPEND="dev-db/sqlite:3
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
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

REQUIRED_USE="theora? ( vorbis )"
PATCHES=(
	"${FILESDIR}/${PN}"-2.3.0-debug.patch
	"${FILESDIR}/${PN}"-2.3.0-doc.patch
)

src_configure() {
	# there are in-source switches
	use debug && CMAKE_BUILD_TYPE=Debug

	local mycmakeargs=(
		-DGAMEDIR="/usr/bin"
		-DDOCDIR="/usr/share/doc/${PF}"
		-DWITH_BZIP2=$(usex bzip2)
		-DENABLE_DOC=$(usex doc)
		-DWITH_FLUIDSYNTH=$(usex fluidsynth)
		-DWITH_MIKMOD=$(usex mikmod)
		-DWITH_MNG=$(usex mng)
		-DWITH_OGGVORBIS=$(usex vorbis)
		-DWITH_THEORA=$(usex theora)
		-DENABLE_DEV=ON
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
