# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER="3.0"
inherit cmake-utils wxwidgets gnome2-utils fdo-mime games

if [[ ${PV} == 9999 ]]; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/vbam/code/trunk"
	inherit subversion
else
	SRC_URI="https://dev.gentoo.org/~radhermit/distfiles/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Game Boy, GBC, and GBA emulator forked from VisualBoyAdvance"
HOMEPAGE="http://sourceforge.net/projects/vbam/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="cairo ffmpeg gtk link lirc nls openal +sdl wxwidgets"
REQUIRED_USE="|| ( sdl gtk wxwidgets )"

RDEPEND=">=media-libs/libpng-1.4:0=
	media-libs/libsdl[sound]
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
	wxwidgets? ( || (
		media-gfx/imagemagick
		media-gfx/graphicsmagick[imagemagick] ) )
	x86? ( || ( dev-lang/nasm dev-lang/yasm ) )
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	[[ ${PV} == 9999 ]] && subversion_src_prepare

	# fix issue with zlib-1.2.5.1 macros (bug #383179)
	sed -i '1i#define OF(x) x' src/common/memgzio.c || die

	sed -i "s:\(DESTINATION\) bin:\1 ${GAMES_BINDIR}:" \
		CMakeLists.txt src/{wx,gtk}/CMakeLists.txt || die
	epatch "${FILESDIR}"/${P}-man.patch
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable cairo CAIRO)
		$(cmake-utils_use_enable ffmpeg FFMPEG)
		$(cmake-utils_use_enable gtk GTK)
		$(cmake-utils_use_enable link LINK)
		$(cmake-utils_use_enable lirc LIRC)
		$(cmake-utils_use_enable nls NLS)
		$(cmake-utils_use_enable openal OPENAL)
		$(cmake-utils_use_enable sdl SDL)
		$(cmake-utils_use_enable wxwidgets WX)
		$(cmake-utils_use_enable x86 ASM_CORE)
		$(cmake-utils_use_enable x86 ASM_SCALERS)
		-DCMAKE_SKIP_RPATH=ON
		-DDATA_INSTALL_DIR=share/games/${PN}
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	use sdl && dodoc doc/ReadMe.SDL.txt
	prepgamesdirs
}

pkg_preinst() {
	[[ ${PV} == 9999 ]] && subversion_pkg_preinst

	games_pkg_preinst
	if use gtk || use wxwidgets ; then
		gnome2_icon_savelist
	fi
}

pkg_postinst() {
	games_pkg_postinst
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
