# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"
inherit cmake-utils wxwidgets gnome2-utils fdo-mime

if [[ ${PV} == 9999 ]]; then
	ESVN_REPO_URI="https://github.com/visualboyadvance-m/visualboyadvance-m.git"
	inherit git
else
	SRC_URI="https://github.com/visualboyadvance-m/visualboyadvance-m/archive/c2165287938aea2306a75f0714744a6d23ba7dab.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
	inherit vcs-snapshot
fi

DESCRIPTION="Game Boy, GBC, and GBA emulator forked from VisualBoyAdvance"
HOMEPAGE="http://vba-m.com/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="cairo ffmpeg gtk link lirc nls openal +sdl wxwidgets"
REQUIRED_USE="|| ( sdl gtk wxwidgets )"

RDEPEND="media-libs/libpng:0=
	media-libs/libsdl2[sound]
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	link? ( >=media-libs/libsfml-2.0 )
	ffmpeg? ( virtual/ffmpeg[-libav] )
	lirc? ( app-misc/lirc )
	nls? ( virtual/libintl )
	sdl? ( media-libs/libsdl[joystick,opengl] )
	gtk? ( >=dev-cpp/glibmm-2.4.0:2
		>=dev-cpp/gtkmm-2.4.0:2.4
		>=dev-cpp/gtkglextmm-1.2.0 )
	wxwidgets? (
		cairo? ( x11-libs/cairo )
		openal? ( media-libs/openal )
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	)"
DEPEND="${RDEPEND}
	wxwidgets? ( virtual/imagemagick-tools )
	x86? ( || ( dev-lang/nasm dev-lang/yasm ) )
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

PATCHES=(
	# fix issue with zlib-1.2.5.1 macros (bug #383179)
	"${FILESDIR}"/${PN}-2.0.0_beta2-fix-zlib-macros.patch
	"${FILESDIR}"/${PN}-2.0.0_beta2-fix-install-path-bin.patch
	"${FILESDIR}"/${PN}-2.0.0_beta2-remove-hardcoded-flags.patch
)

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
		-DDATA_INSTALL_DIR=share/${PN}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use sdl && dodoc doc/ReadMe.SDL.txt
}

pkg_preinst() {
	[[ ${PV} == *9999 ]] && subversion_pkg_preinst

	if use gtk || use wxwidgets ; then
		gnome2_icon_savelist
	fi
}

pkg_postinst() {
	if use gtk || use wxwidgets ; then
		gnome2_icon_cache_update
		use gtk && fdo-mime_desktop_database_update
	fi
}

pkg_postrm() {
	if use gtk || use wxwidgets ; then
		gnome2_icon_cache_update
		use gtk && fdo-mime_desktop_database_update
	fi
}
