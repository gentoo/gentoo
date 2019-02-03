# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="Game Boy Advance emulator written in C"
HOMEPAGE="https://mgba.io"
SRC_URI="https://github.com/${PN}-emu/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug ffmpeg imagemagick libav opengl qt5 +sdl"
REQUIRED_USE="|| ( qt5 sdl )
		qt5? ( opengl )"

RDEPEND="
	dev-db/sqlite:3
	media-libs/libpng:0=
	sys-libs/zlib[minizip]
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:= )
	)
	imagemagick? ( media-gfx/imagemagick:= )
	opengl? ( virtual/opengl )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtwidgets:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	sdl? ( media-libs/libsdl2[X,sound,joystick,video,opengl?] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-qt511.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	# Get rid of any bundled stuff we don't want
	for pkg in libpng lzma sqlite3 zlib ; do
		rm -r src/third-party/${pkg} || die
	done
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_GL="$(usex opengl)"
		-DBUILD_PYTHON=OFF
		-DBUILD_QT="$(usex qt5)"
		-DBUILD_SDL="$(usex sdl)"
		-DBUILD_SHARED=ON
		# test suite fails to build (0.6.0)
		-DBUILD_SUITE=OFF
		-DBUILD_TEST=OFF
		-DM_CORE_GB=ON
		-DM_CORE_GBA=ON
		-DUSE_DEBUGGERS="$(usex debug)"
		-DUSE_EDITLINE="$(usex debug)"
		-DUSE_EPOXY=OFF
		-DUSE_FFMPEG="$(usex ffmpeg)"
		-DUSE_GDB_STUB="$(usex debug)"
		-DUSE_LIBZIP=OFF
		-DUSE_LZMA=OFF
		-DUSE_MAGICK="$(usex imagemagick)"
		-DUSE_MINIZIP=ON
		-DUSE_PNG=ON
		# build fails with sqlite being disabled (0.6.3)
		-DUSE_SQLITE3=ON
		-DUSE_ZLIB=ON
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	if use qt5 ; then
		dobin ../${P}_build/qt/${PN}-qt
		doman doc/${PN}-qt.6
		domenu res/${PN}-qt.desktop
		for size in 16 24 32 48 64 96 128 256; do
			newicon -s ${size} res/${PN}-${size}.png ${PN}.png
		done
	fi
	if use sdl ; then
		doman doc/${PN}.6
		newbin ../${P}_build/sdl/${PN} ${PN}-sdl
	fi

	dolib.so ../${P}_build/lib${PN}.so*
}

pkg_preinst() {
	if use qt5 ; then
		gnome2_icon_savelist
	fi
}

pkg_postinst() {
	if use qt5 ; then
		xdg_desktop_database_update
		gnome2_icon_cache_update
	fi
}

pkg_postrm() {
	if use qt5 ; then
		xdg_desktop_database_update
		gnome2_icon_cache_update
	fi
}
