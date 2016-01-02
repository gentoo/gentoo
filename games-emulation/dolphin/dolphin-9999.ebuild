# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"

inherit cmake-utils eutils pax-utils toolchain-funcs versionator wxwidgets games

if [[ ${PV} == 9999* ]]
then
	EGIT_REPO_URI="https://github.com/dolphin-emu/dolphin"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}-emu/${PN}/archive/${PV}.zip -> ${P}.zip"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Gamecube and Wii game emulator"
HOMEPAGE="https://www.dolphin-emu.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa ao bluetooth doc egl +evdev ffmpeg llvm log lto openal +pch portaudio profile pulseaudio qt5 sdl upnp +wxwidgets"

RDEPEND=">=media-libs/libsfml-2.1
	>net-libs/enet-1.3.7
	>=net-libs/mbedtls-2.1.1
	dev-libs/lzo
	media-libs/libpng:=
	sys-libs/glibc
	sys-libs/readline:=
	sys-libs/zlib
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	virtual/libusb:1
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	bluetooth? ( net-wireless/bluez )
	egl? ( media-libs/mesa[egl] )
	evdev? (
			dev-libs/libevdev
			virtual/udev
	)
	ffmpeg? (
			virtual/ffmpeg
			!!media-video/libav
	)
	llvm? ( sys-devel/llvm )
	openal? (
			media-libs/openal
			media-libs/libsoundtouch
	)
	portaudio? ( media-libs/portaudio )
	profile? ( dev-util/oprofile )
	pulseaudio? ( media-sound/pulseaudio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	sdl? ( media-libs/libsdl2[haptic,joystick] )
	upnp? ( >=net-libs/miniupnpc-1.7 )
	wxwidgets? (
				dev-libs/glib:2
				x11-libs/gtk+:2
				x11-libs/wxGTK:${WX_GTK_VER}[opengl,X]
	)
	"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8.8
	>=sys-devel/gcc-4.9.0
	app-arch/zip
	media-libs/freetype
	sys-devel/gettext
	virtual/pkgconfig
	"

pkg_pretend() {

	local ver=4.9.0
	local msg="${PN} needs at least GCC ${ver} set to compile."

	if [[ ${MERGE_TYPE} != binary ]]; then
		if ! version_is_at_least ${ver} $(gcc-fullversion); then
			eerror ${msg}
			die ${msg}
		fi
	fi

}

src_prepare() {

	# Remove automatic dependencies to prevent building without flags enabled.
	if use !alsa; then
		sed -i -e '/include(FindALSA/d' CMakeLists.txt || die
	fi
	if use !ao; then
		sed -i -e '/check_lib(AO/d' CMakeLists.txt || die
	fi
	if use !bluetooth; then
		sed -i -e '/check_lib(BLUEZ/d' CMakeLists.txt || die
	fi
	if use !llvm; then
		sed -i -e '/include(FindLLVM/d' CMakeLists.txt || die
	fi
	if use !openal; then
		sed -i -e '/include(FindOpenAL/d' CMakeLists.txt || die
	fi
	if use !portaudio; then
		sed -i -e '/CMAKE_REQUIRED_LIBRARIES portaudio/d' CMakeLists.txt || die
	fi
	if use !pulseaudio; then
		sed -i -e '/check_lib(PULSEAUDIO/d' CMakeLists.txt || die
	fi

	# Remove ALL the bundled libraries, aside from:
	# - SOIL: The sources are not public.
	# - Bochs-disasm: Don't know what it is.
	# - GL: A custom gl.h file is used.
	# - gtest: Their build set up solely relies on the build in gtest.
	# - xxhash: Not on the tree.
	mv Externals/SOIL . || die
	mv Externals/Bochs_disasm . || die
	mv Externals/GL . || die
	mv Externals/gtest . || die
	mv Externals/xxhash . || die
	rm -r Externals/* || die "Failed to delete Externals dir."
	mv Bochs_disasm Externals || die
	mv SOIL Externals || die
	mv GL Externals || die
	mv gtest Externals || die
	mv xxhash Externals || die
}

src_configure() {

	if use wxwidgets; then
		need-wxwidgets unicode
	fi

	local mycmakeargs=(
		"-DDOLPHIN_WC_REVISION=${PV}"
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-Dprefix=${GAMES_PREFIX}"
		"-Ddatadir=${GAMES_DATADIR}/${PN}"
		"-Dplugindir=$(games_get_libdir)/${PN}"
		"-DUSE_SHARED_ENET=ON"
		$( cmake-utils_use ffmpeg ENCODE_FRAMEDUMPS )
		$( cmake-utils_use log FASTLOG )
		$( cmake-utils_use profile OPROFILING )
		$( cmake-utils_use_disable wxwidgets WX )
		$( cmake-utils_use_enable evdev EVDEV )
		$( cmake-utils_use_enable lto LTO )
		$( cmake-utils_use_enable pch PCH )
		$( cmake-utils_use_enable qt5 QT )
		$( cmake-utils_use_enable sdl SDL )
		$( cmake-utils_use_use egl EGL )
		$( cmake-utils_use_use upnp UPNP )
	)

	cmake-utils_src_configure
}

src_compile() {

	cmake-utils_src_compile
}
src_install() {

	cmake-utils_src_install

	dodoc Readme.md
	if use doc; then
		dodoc -r docs/ActionReplay docs/DSP docs/WiiMote
	fi

	doicon Installer/dolphin-emu.xpm
	make_desktop_entry "dolphin-emu" "Dolphin Emulator" "dolphin-emu" "Game;Emulator;"

	prepgamesdirs
}

pkg_postinst() {
	# Add pax markings for hardened systems
	pax-mark -m "${EPREFIX}"/usr/games/bin/"${PN}"-emu

	if ! use portaudio; then
		ewarn "If you want microphone capabilities in dolphin-emu, rebuild with"
		ewarn "USE=\"portaudio\""
	fi
}
