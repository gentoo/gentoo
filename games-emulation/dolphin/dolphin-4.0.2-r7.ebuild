# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"

inherit cmake-utils eutils pax-utils toolchain-funcs versionator wxwidgets games

SRC_URI="https://github.com/${PN}-emu/${PN}/archive/${PV}.zip -> ${P}.zip"
KEYWORDS="~amd64"

DESCRIPTION="Gamecube and Wii game emulator"
HOMEPAGE="https://www.dolphin-emu.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa ao bluetooth doc ffmpeg +lzo openal opengl openmp portaudio pulseaudio"

RESTRICT="mirror"

RDEPEND=">=media-libs/glew-1.6
	<media-libs/libsfml-2.0
	>=net-libs/miniupnpc-1.8
	media-libs/libsdl2[haptic,joystick]
	sys-libs/readline:=
	x11-libs/libXext
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	bluetooth? ( net-wireless/bluez )
	ffmpeg? ( virtual/ffmpeg
		!!>=media-video/libav-10 )
	lzo? ( dev-libs/lzo )
	openal? ( media-libs/openal )
	opengl? ( virtual/opengl )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	"
DEPEND="${RDEPEND}
	app-arch/zip
	media-gfx/nvidia-cg-toolkit
	media-libs/freetype
	media-libs/libsoundtouch
	>=sys-devel/gcc-4.6.0
	x11-libs/wxGTK:${WX_GTK_VER}
	"

pkg_pretend() {

	local ver=4.6.0
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
	# - CLRun: Part of OpenCL
	# - polarssl: Currently fails the check as is.
	mv Externals/SOIL . || die
	mv Externals/Bochs_disasm . || die
	mv Externals/CLRun . || die
	mv Externals/polarssl . || die
	rm -r Externals/* || die
	mv polarssl Externals || die
	mv CLRun Externals || die
	mv Bochs_disasm Externals || die
	mv SOIL Externals || die

	# Add call for FindX11 as FindOpenGL does not include it implicitly
	# anymore for >=cmake-3.2. For more info, see: 
	# https://public.kitware.com/Bug/print_bug_page.php?bug_id=15268
	if has_version ">=dev-util/cmake-3.2"; then
		sed -i -e '/if(NOT ANDROID)/a include(FindX11)' CMakeLists.txt || die

		# Fix syntax warnings in FindMiniupnpc.cmake
		sed -i -e 's/\"\"/\\\"\\\"/g' CMakeTests/FindMiniupnpc.cmake || die
	fi
}

src_configure() {

	local mycmakeargs=(
		"-DDOLPHIN_WC_REVISION=${PV}"
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-Dprefix=${GAMES_PREFIX}"
		"-Ddatadir=${GAMES_DATADIR}/${PN}"
		"-Dplugindir=$(games_get_libdir)/${PN}"
		$( cmake-utils_use ffmpeg ENCODE_FRAMEDUMPS )
		$( cmake-utils_use openmp OPENMP )
	)

	cmake-utils_src_configure
}

src_compile() {

	cmake-utils_src_compile
}

src_install() {

	cmake-utils_src_install

	dodoc Readme.txt
	if use doc; then
		dodoc -r docs/ActionReplay docs/DSP docs/WiiMote
	fi

	doicon Source/Core/DolphinWX/resources/Dolphin.xpm
	make_desktop_entry "dolphin-emu" "Dolphin" "Dolphin" "Game;"

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
