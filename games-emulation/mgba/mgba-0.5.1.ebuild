# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit fdo-mime gnome2-utils cmake-utils

DESCRIPTION="A new Game Boy Advance emulator written in C."
HOMEPAGE="https://mgba.io"
SRC_URI="https://github.com/${PN}-emu/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg imagemagick opengl qt5 +sdl"
REQUIRED_USE="|| ( qt5 sdl )
		qt5? ( opengl )"

RDEPEND="
	media-libs/libpng:0=
	sys-libs/zlib[minizip]
	ffmpeg? ( virtual/ffmpeg )
	imagemagick? ( media-gfx/imagemagick:= )
	opengl? ( virtual/opengl )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtwidgets:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	sdl? ( media-libs/libsdl2[X,sound,joystick,video,opengl?] )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.2.2"

src_prepare() {
	default

	# Get rid of any bundled stuff we don't want
	for pkg in libpng lzma zlib ; do
		rm -r "${S}"/src/third-party/${pkg} || die
	done
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_GL="$(usex opengl)"
		-DBUILD_QT="$(usex qt5)"
		-DBUILD_SDL="$(usex sdl)"
		-DUSE_FFMPEG="$(usex ffmpeg)"
		-DUSE_MAGICK="$(usex imagemagick)"
		-DUSE_EPOXY=OFF
		-DUSE_LIBZIP=OFF
		-DUSE_LZMA=OFF
		-DUSE_MINIZIP=ON
		-DM_CORE_GB=ON
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	if use qt5 ; then
		for size in 16 24 32 48 64 96 128 256; do
			newicon -s ${size} res/${PN}-${size}.png ${PN}.png
		done
		doman doc/${PN}-qt.6
		domenu res/${PN}-qt.desktop
		dobin ../${P}_build/qt/${PN}-qt
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
		fdo-mime_desktop_database_update
		gnome2_icon_cache_update
	fi
}

pkg_postrm() {
	if use qt5 ; then
		fdo-mime_desktop_database_update
		gnome2_icon_cache_update
	fi
}
