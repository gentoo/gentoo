# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

DESCRIPTION="Game Boy Advance emulator written in C"
HOMEPAGE="https://mgba.io"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mgba-emu/mgba.git"
else
	MY_PV="${PV/_beta/-b}"
	SRC_URI="https://github.com/${PN}-emu/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	[[ "${PV}" == *_beta* ]] || \
	KEYWORDS="amd64 ~arm64 x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
LICENSE="MPL-2.0"
SLOT="0"
IUSE="debug discord elf ffmpeg gles2 gles3 opengl qt5 +sdl sqlite"
REQUIRED_USE="|| ( qt5 sdl )
		qt5? ( opengl )"

RDEPEND="
	media-libs/libpng:0=
	sys-libs/zlib[minizip]
	elf? ( dev-libs/elfutils )
	ffmpeg? ( media-video/ffmpeg:= )
	opengl? ( media-libs/libglvnd )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtwidgets:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	sdl? ( media-libs/libsdl2[X,sound,joystick,video,opengl?] )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}
	gles2? ( media-libs/libglvnd )
	gles3? ( media-libs/libglvnd )
"

src_prepare() {
	xdg_environment_reset
	cmake_src_prepare

	# Get rid of any bundled stuff we don't want
	local pkg
	for pkg in libpng lzma sqlite3 zlib ; do
		rm -r src/third-party/${pkg} || die
	done
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_GL="$(usex opengl)"
		-DBUILD_GLES2="$(usex gles2)"
		-DBUILD_GLES3="$(usex gles3)"
		-DBUILD_PYTHON=OFF
		-DBUILD_QT="$(usex qt5)"
		-DBUILD_SDL="$(usex sdl)"
		-DBUILD_SHARED=ON
		# test suite fails to build (>=0.6.0)
		-DBUILD_SUITE=OFF
		-DBUILD_TEST=OFF
		-DM_CORE_GB=ON
		-DM_CORE_GBA=ON
		-DUSE_DEBUGGERS="$(usex debug)"
		-DUSE_DISCORD_RPC="$(usex discord)"
		-DUSE_EDITLINE="$(usex debug)"
		-DUSE_ELF="$(usex elf)"
		-DUSE_EPOXY=OFF
		-DUSE_FFMPEG="$(usex ffmpeg)"
		-DUSE_GDB_STUB="$(usex debug)"
		-DUSE_LIBZIP=OFF
		-DUSE_LZMA=OFF
		-DUSE_MINIZIP=ON
		-DUSE_PNG=ON
		-DUSE_SQLITE3="$(usex sqlite)"
		-DUSE_ZLIB=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	if use qt5 ; then
		dobin ${BUILD_DIR}/qt/${PN}-qt
		doman doc/${PN}-qt.6
		domenu res/${PN}-qt.desktop
		for size in 16 24 32 48 64 96 128 256 ; do
			newicon -s ${size} res/${PN}-${size}.png ${PN}.png
		done
	fi
	if use sdl ; then
		doman doc/${PN}.6
		newbin ${BUILD_DIR}/sdl/${PN} ${PN}-sdl
	fi

	dolib.so ${BUILD_DIR}/lib${PN}.so*
}

pkg_preinst() {
	if use qt5 ; then
		xdg_pkg_preinst
	fi
}

pkg_postinst() {
	if use qt5 ; then
		xdg_pkg_postinst
	fi
}

pkg_postrm() {
	if use qt5 ; then
		xdg_pkg_postrm
	fi
}
