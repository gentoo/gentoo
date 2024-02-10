# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit wxwidgets xdg cmake

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

REQUIRED_USE="
	ffmpeg? ( wxwidgets )
	openal? ( wxwidgets )
	|| ( sdl wxwidgets )
"

RDEPEND="
	>=media-libs/libpng-1.4:=
	media-libs/libsdl2[joystick]
	sys-libs/zlib:=
	virtual/glu
	virtual/opengl
	link? ( >=media-libs/libsfml-2.0:= )
	lirc? ( app-misc/lirc )
	nls? ( virtual/libintl )
	wxwidgets? (
		ffmpeg? ( media-video/ffmpeg:= )
		openal? ( media-libs/openal )
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-arch/zip
	virtual/pkgconfig
	wxwidgets? ( virtual/imagemagick-tools )
	amd64? ( || ( dev-lang/nasm dev-lang/yasm ) )
	x86? ( || ( dev-lang/nasm dev-lang/yasm ) )
	nls? ( sys-devel/gettext )
"

src_prepare() {
	cmake_src_prepare
	sed -i 's/ -mtune=generic//g' CMakeLists.txt || die
}

src_configure() {
	use wxwidgets && setup-wxwidgets

	local mycmakeargs=(
		-DENABLE_FFMPEG=$(usex ffmpeg)
		-DENABLE_LINK=$(usex link)
		-DENABLE_LIRC=$(usex lirc)
		-DENABLE_NLS=$(usex nls)
		-DENABLE_SDL=$(usex sdl)
		-DENABLE_WX=$(usex wxwidgets)
		-DENABLE_ASM_CORE=$(usex x86)
		-DENABLE_ASM_SCALERS=$(usex x86)
		-DCMAKE_SKIP_RPATH=ON
		-DENABLE_LTO=OFF
		-DENABLE_ONLINEUPDATES=OFF
		-DDISABLE_MACOS_PACKAGE_MANAGERS=ON
	)

	if use wxwidgets; then
		mycmakeargs+=( -DENABLE_OPENAL=$(usex openal) )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use sdl ; then
		dodoc doc/ReadMe.SDL.txt
		doman src/debian/vbam.6
	fi

	use wxwidgets && doman src/debian/visualboyadvance-m.6
}

pkg_preinst() {
	if use wxwidgets ; then
		xdg_pkg_preinst
	fi
}

pkg_postinst() {
	if use wxwidgets ; then
		xdg_pkg_postinst
	fi
}

pkg_postrm() {
	if use wxwidgets ; then
		xdg_pkg_postrm
	fi
}
