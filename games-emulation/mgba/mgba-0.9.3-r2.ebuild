# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mgba-emu/mgba.git"
else
	SRC_URI="https://github.com/mgba-emu/mgba/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="Game Boy Advance Emulator"
HOMEPAGE="https://mgba.io/"

LICENSE="MPL-2.0 BSD LGPL-2.1+ public-domain discord? ( MIT )"
SLOT="0/9"
IUSE="debug discord elf ffmpeg gles2 gles3 gui libretro opengl +sdl sqlite test"
# gles2/gles3 opengl require can be lifted in next version (bug #835039)
REQUIRED_USE="
	|| ( gui sdl )
	gles2? ( opengl )
	gles3? ( opengl )
	gui? ( || ( gles2 opengl ) )"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libpng:=
	sys-libs/zlib:=[minizip]
	debug? ( dev-libs/libedit )
	elf? ( dev-libs/elfutils )
	ffmpeg? ( media-video/ffmpeg:= )
	gles2? ( media-libs/libglvnd )
	gles3? ( media-libs/libglvnd )
	opengl? ( media-libs/libglvnd )
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	sdl? ( media-libs/libsdl2[sound,joystick,opengl?,video] )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )"

PATCHES=(
	"${FILESDIR}"/${P}-ffmpeg5.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_CINEMA=$(usex test)
		-DBUILD_GL=$(usex opengl)
		-DBUILD_GLES2=$(usex gles2)
		-DBUILD_GLES3=$(usex gles3)
		-DBUILD_LIBRETRO=$(usex libretro)
		-DBUILD_QT=$(usex gui)
		-DBUILD_SDL=$(usex sdl)
		-DBUILD_SUITE=$(usex test)
		-DMARKDOWN=OFF #752048
		-DUSE_DEBUGGERS=$(usex debug)
		-DUSE_DISCORD_RPC=$(usex discord)
		-DUSE_EDITLINE=$(usex debug)
		-DUSE_ELF=$(usex elf)
		-DUSE_EPOXY=OFF
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_GDB_STUB=$(usex debug)
		-DUSE_LIBZIP=OFF
		-DUSE_LZMA=ON
		-DUSE_MINIZIP=ON
		-DUSE_PNG=ON
		-DUSE_SQLITE3=$(usex sqlite)
		-DUSE_ZLIB=ON
		$(usev libretro -DLIBRETRO_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/libretro)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	use !test || rm "${ED}"/usr/bin/mgba-cinema || die

	rm -r "${ED}"/usr/share/doc/${PF}/{LICENSE,licenses} || die
}
