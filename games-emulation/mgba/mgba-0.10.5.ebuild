# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3..4} )
inherit cmake lua-single xdg

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
SLOT="0/$(ver_cut 1-2)"
IUSE="
	debug discord elf ffmpeg gles2 gles3 gui libretro
	lua +opengl +sdl +sqlite test
"
REQUIRED_USE="
	gui? ( || ( gles2 gles3 opengl ) sqlite )
	lua? ( ${LUA_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libpng:=
	sys-libs/zlib:=[minizip]
	debug? ( dev-libs/libedit )
	elf? ( dev-libs/elfutils )
	ffmpeg? ( media-video/ffmpeg:= )
	gles2? ( media-libs/libglvnd )
	gles3? ( media-libs/libglvnd )
	lua? ( ${LUA_DEPS} )
	opengl? ( media-libs/libglvnd )
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	sdl? ( media-libs/libsdl2[sound,joystick,gles2?,opengl?,video] )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"
BDEPEND="
	gui? ( dev-qt/linguist-tools:5 )
	lua? ( virtual/pkgconfig )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.0-optional-updater.patch
	"${FILESDIR}"/${P}-cmake4.patch
)

CMAKE_QA_COMPAT_SKIP=1 #958356

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CINEMA=$(usex test)
		-DBUILD_GL=$(usex opengl)
		-DBUILD_GLES2=$(usex gles2)
		-DBUILD_GLES3=$(usex gles3)
		-DBUILD_LIBRETRO=$(usex libretro)
		-DBUILD_QT=$(usex gui)
		-DBUILD_ROM_TEST=yes #918855
		-DBUILD_SDL=$(usex sdl) # also used for gamepads in QT build
		-DBUILD_SUITE=$(usex test)
		-DBUILD_UPDATER=no
		-DENABLE_SCRIPTING=$(usex lua)
		-DMARKDOWN=no #752048
		-DUSE_DEBUGGERS=$(usex debug)
		-DUSE_DISCORD_RPC=$(usex discord)
		-DUSE_EDITLINE=$(usex debug)
		-DUSE_ELF=$(usex elf)
		-DUSE_EPOXY=no
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_GDB_STUB=$(usex debug)
		-DUSE_LIBZIP=no
		-DUSE_LZMA=yes
		-DUSE_MINIZIP=yes
		-DUSE_PNG=yes
		-DUSE_SQLITE3=$(usex sqlite)
		-DUSE_ZLIB=yes
		$(usev libretro -DLIBRETRO_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/libretro)
	)
	use lua && mycmakeargs+=( -DUSE_LUA=$(ver_cut 1-2 $(lua_get_version)) )

	cmake_src_configure
}

src_test() {
	# CMakeLists.txt forces SKIP_RPATH=yes when PREFIX=/usr
	local -x LD_LIBRARY_PATH=${BUILD_DIR}:${LD_LIBRARY_PATH}

	cmake_src_test
}

src_install() {
	cmake_src_install

	use !test || rm "${ED}"/usr/bin/mgba-cinema || die

	rm -r -- "${ED}"/usr/share/doc/${PF}/{LICENSE,licenses} || die
}
