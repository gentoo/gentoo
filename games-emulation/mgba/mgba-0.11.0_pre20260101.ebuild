# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# can recognize luajit but tests currently fail with it
LUA_COMPAT=( lua5-{3..4} )
inherit cmake lua-single xdg

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mgba-emu/mgba.git"
else
	MGBA_HASH=e8ef4be03cc8de9cc19f03778eadc375f6269d5a
	SRC_URI="
		https://github.com/mgba-emu/mgba/archive/${MGBA_HASH}.tar.gz
			-> ${P}.tar.gz
	"
	KEYWORDS="amd64 arm64 ~ppc64 ~x86"
	S=${WORKDIR}/${PN}-${MGBA_HASH}
fi

DESCRIPTION="Game Boy Advance Emulator"
HOMEPAGE="https://mgba.io/"

LICENSE="MPL-2.0 BSD LGPL-2.1+ public-domain discord? ( MIT )"
SLOT="0/$(ver_cut 1-2)"
IUSE="
	debug discord elf ffmpeg gles2 gles3 gui libretro
	lua +opengl +sdl +sqlite test
"
# gles3+gui with neither gles2 nor opengl currently fails to build
REQUIRED_USE="
	gui? (
		|| ( gles2 gles3 opengl ) sqlite
		gles3? ( || ( gles2 opengl ) )
	)
	lua? ( ${LUA_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/freetype
	media-libs/libpng:=
	virtual/minizip:=
	debug? ( dev-libs/libedit )
	elf? ( dev-libs/elfutils )
	ffmpeg? ( media-video/ffmpeg:= )
	gles2? ( media-libs/libglvnd )
	gles3? ( media-libs/libglvnd )
	lua? (
		${LUA_DEPS}
		dev-libs/json-c:=
	)
	opengl? ( media-libs/libglvnd )
	gui? (
		dev-qt/qtbase:6[gui,network,opengl,widgets]
		dev-qt/qtmultimedia:6
	)
	sdl? ( media-libs/libsdl2[sound,joystick,gles2?,opengl?,video] )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"
BDEPEND="
	gui? ( dev-qt/qttools:6[linguist] )
	lua? ( virtual/pkgconfig )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.0-optional-updater.patch
	"${FILESDIR}"/${PN}-0.11.0_pre20260101-debugger.patch
)

CMAKE_QA_COMPAT_SKIP=1 #958356

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_configure() {
	# has unwanted logic with RelWithDebInfo
	local -x CMAKE_BUILD_TYPE=Release

	local mycmakeargs=(
		-DBUILD_CINEMA=$(usex test)
		-DBUILD_GL=$(usex opengl)
		-DBUILD_GLES2=$(usex gles2)
		-DBUILD_GLES3=$(usex gles3)
		-DBUILD_HEADLESS=yes #918855
		-DBUILD_LIBRETRO=$(usex libretro)
		-DBUILD_LTO=no # let users' flags handle this
		-DBUILD_QT=$(usex gui)
		$(usev gui -DFORCE_QT_VERSION=6)
		-DBUILD_SDL=$(usex sdl) # also used for gamepads in QT build
		-DBUILD_SUITE=$(usex test)
		-DBUILD_UPDATER=no
		-DENABLE_DEBUGGERS=$(usex debug)
		-DENABLE_GDB_STUB=$(usex debug)
		-DENABLE_SCRIPTING=$(usex lua)
		-DMARKDOWN=no #752048
		-DSKIP_GIT=yes
		-DUSE_DISCORD_RPC=$(usex discord)
		-DUSE_EDITLINE=$(usex debug)
		-DUSE_ELF=$(usex elf)
		-DUSE_EPOXY=no
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FREETYPE=yes
		-DUSE_JSON_C=yes
		-DUSE_LIBZIP=no
		$(usev lua -DUSE_LUA="${ELUA#lua}")
		-DUSE_LZMA=yes
		-DUSE_MINIZIP=yes
		-DUSE_PNG=yes
		-DUSE_SQLITE3=$(usex sqlite)
		-DUSE_ZLIB=yes
		$(usev libretro -DLIBRETRO_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/libretro)
	)

	cmake_src_configure
}

src_test() {
	# CMakeLists.txt forces SKIP_RPATH=yes when PREFIX=/usr
	local -x LD_LIBRARY_PATH=${BUILD_DIR}:${LD_LIBRARY_PATH}
	local -x QT_QPA_PLATFORM=offscreen

	cmake_src_test
}

src_install() {
	cmake_src_install

	use !test || rm "${ED}"/usr/bin/mgba-cinema || die

	rm -r -- "${ED}"/usr/share/doc/${PF}/{LICENSE,licenses} || die
}

pkg_preinst() {
	xdg_pkg_preinst

	# hack: .shader/ were directories in <0.11 and are now single (zip) files
	# named the same, that leads to portage mis-merging and leaving an empty
	# directory behind rather than the new file
	if use gui && has_version '<games-emulation/mgba-0.11[gui]'; then
		rm -rf -- "${EROOT}"/usr/share/mgba/shaders/*.shader/ || die
	fi
}
