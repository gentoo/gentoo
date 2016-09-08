# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
WX_GTK_VER="3.0"
inherit cmake-utils wxwidgets gnome2-utils fdo-mime eutils

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/visualboyadvance-m/visualboyadvance-m.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~radhermit/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Game Boy, GBC, and GBA emulator forked from VisualBoyAdvance"
HOMEPAGE="https://github.com/visualboyadvance-m/visualboyadvance-m"

LICENSE="GPL-2"
SLOT="0"
IUSE="cairo ffmpeg gtk link lirc nls openal +sdl wxwidgets"
REQUIRED_USE="|| ( sdl gtk wxwidgets )"

RDEPEND=">=media-libs/libpng-1.4:0=
	media-libs/libsdl[joystick]
	link? ( >=media-libs/libsfml-2.0:= )
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	ffmpeg? ( virtual/ffmpeg[-libav] )
	gtk? ( >=dev-cpp/glibmm-2.4.0:2
		>=dev-cpp/gtkmm-2.4.0:2.4
		>=dev-cpp/gtkglextmm-1.2.0 )
	lirc? ( app-misc/lirc )
	nls? ( virtual/libintl )
	wxwidgets? (
		cairo? ( x11-libs/cairo )
		openal? ( media-libs/openal )
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	)"
DEPEND="${RDEPEND}
	wxwidgets? ( || ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] ) )
	x86? ( || ( dev-lang/nasm dev-lang/yasm ) )
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	default

	# fix desktop file QA warnings
	edos2unix src/gtk/gvbam.desktop src/wx/wxvbam.desktop
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CAIRO=$(usex cairo)
		-DENABLE_FFMPEG=$(usex ffmpeg)
		-DENABLE_GTK=$(usex gtk)
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

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	if use sdl ; then
		dodoc doc/ReadMe.SDL.txt
		doman src/debian/vbam.1
	fi
	use wxwidgets && doman src/debian/wxvbam.1
	use gtk && doman src/debian/gvbam.1
}

pkg_preinst() {
	if use gtk || use wxwidgets ; then
		gnome2_icon_savelist
	fi
}

pkg_postinst() {
	if use gtk || use wxwidgets ; then
		gnome2_icon_cache_update
	fi
	use gtk && fdo-mime_desktop_database_update
}

pkg_postrm() {
	if use gtk || use wxwidgets ; then
		gnome2_icon_cache_update
	fi
	use gtk && fdo-mime_desktop_database_update
}
