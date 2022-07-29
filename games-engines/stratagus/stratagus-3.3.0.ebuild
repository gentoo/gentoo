# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 )
inherit cmake lua-single optfeature

DESCRIPTION="A realtime strategy game engine"
HOMEPAGE="
	https://stratagus.com/stratagus.html
	https://github.com/Wargus/stratagus/
"
SRC_URI="
	https://github.com/Wargus/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 debug doc mng theora vorbis"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
	theora? ( vorbis )
"

DEPEND="
	${LUA_DEPS}
	dev-db/sqlite:3
	dev-lua/toluapp[${LUA_SINGLE_USEDEP}]
	media-libs/libpng:0
	x11-libs/libX11
	media-libs/libsdl2[sound,opengl,video]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-image[png]
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	mng? ( media-libs/libmng )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
		theora? ( media-libs/libtheora )
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

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
		-DGAMEDIR="${EPREFIX}/usr/bin"
		-DDOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DWITH_BZIP2=$(usex bzip2)
		-DWITH_MNG=$(usex mng)
		-DWITH_OGGVORBIS=$(usex vorbis)
		-DWITH_THEORA=$(usex theora)
		-DENABLE_DOC=$(usex doc)
		-DENABLE_DEV=ON
	)

	cmake_src_configure
}

pkg_postinst() {
	optfeature "MIDI music support" "media-libs/sdl2-mixer[midi]"
}
