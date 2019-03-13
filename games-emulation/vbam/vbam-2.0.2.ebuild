# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0-gtk3"
inherit gnome2-utils wxwidgets xdg-utils cmake-utils

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/visualboyadvance-m/visualboyadvance-m.git"
	inherit git-r3
else
	SRC_URI="https://github.com/visualboyadvance-m/visualboyadvance-m/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/visualboyadvance-m-${PV}"
fi

DESCRIPTION="Game Boy, GBC, and GBA emulator forked from VisualBoyAdvance"
HOMEPAGE="https://github.com/visualboyadvance-m/visualboyadvance-m"

LICENSE="GPL-2"
SLOT="0"
IUSE="ffmpeg link lirc nls openal +sdl wxwidgets"
REQUIRED_USE="openal? ( wxwidgets ) || ( sdl wxwidgets )"

RDEPEND="
	>=media-libs/libpng-1.4:0=
	media-libs/libsdl2[joystick]
	link? ( >=media-libs/libsfml-2.0:= )
	sys-libs/zlib:=
	virtual/glu
	virtual/opengl
	ffmpeg? ( =media-video/ffmpeg-3*:= )
	lirc? ( app-misc/lirc )
	nls? ( virtual/libintl )
	wxwidgets? (
		openal? ( media-libs/openal )
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	)"
DEPEND="${RDEPEND}
	app-arch/zip
	wxwidgets? ( virtual/imagemagick-tools )
	x86? ( || ( dev-lang/nasm dev-lang/yasm ) )
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_configure() {
	use wxwidgets && setup-wxwidgets
	local mycmakeargs=(
		-DENABLE_FFMPEG=$(usex ffmpeg)
		-DENABLE_LINK=$(usex link)
		-DENABLE_LIRC=$(usex lirc)
		-DENABLE_NLS=$(usex nls)
		-DENABLE_OPENAL=$(usex openal)
		-DENABLE_SDL=$(usex sdl)
		-DENABLE_WX=$(usex wxwidgets)
		-DENABLE_ASM_CORE=$(usex x86)
		-DENABLE_ASM_SCALERS=$(usex x86)
		-DCMAKE_SKIP_RPATH=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use sdl ; then
		dodoc doc/ReadMe.SDL.txt
		doman src/debian/vbam.6
	fi
	use wxwidgets && doman src/debian/visualboyadvance-m.6
}

pkg_preinst() {
	if use wxwidgets ; then
		gnome2_icon_savelist
	fi
}

pkg_postinst() {
	if use wxwidgets ; then
		gnome2_icon_cache_update
		xdg_desktop_database_update
	fi
}

pkg_postrm() {
	if use wxwidgets ; then
		gnome2_icon_cache_update
		xdg_desktop_database_update
	fi
}
