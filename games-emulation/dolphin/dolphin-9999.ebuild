# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar ca cs da de el en es fa fr hr hu it ja ko ms nb nl pl pt pt_BR ro ru sr sv tr zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit cmake-utils desktop gnome2-utils l10n pax-utils

if [[ ${PV} == *9999 ]]
then
	EGIT_REPO_URI="https://github.com/dolphin-emu/dolphin"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}-emu/${PN}/archive/${PV}.zip -> ${P}.zip"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Gamecube and Wii game emulator"
HOMEPAGE="https://www.dolphin-emu.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa ao bluetooth discord-presence doc egl +evdev ffmpeg libav llvm log lto openal portaudio profile pulseaudio +qt5 sdl systemd upnp"

RDEPEND="
	>=media-libs/libsfml-2.1
	>net-libs/enet-1.3.7
	>=net-libs/mbedtls-2.1.1:=
	dev-libs/hidapi:0=
	dev-libs/lzo:2=
	dev-libs/pugixml:0=
	media-libs/libpng:0=
	net-misc/curl:0=
	sys-libs/readline:0=
	sys-libs/zlib:0=
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
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:= )
	)
	llvm? ( sys-devel/llvm:* )
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
	systemd? ( sys-apps/systemd:0= )
	upnp? ( >=net-libs/miniupnpc-1.7 )
"
DEPEND="${RDEPEND}
	app-arch/zip
	dev-util/vulkan-headers
	media-libs/freetype
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	cmake-utils_src_prepare

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

	# Remove all the bundled libraries that support system-installed
	# preference. See CMakeLists.txt for conditional 'add_subdirectory' calls.
	local KEEP_SOURCES=(
		Bochs_disasm
		cpp-optparse
		glslang
		# FIXME: xxhash can't be found by cmake
		xxhash
		# soundtouch uses shorts, not floats
		soundtouch
		cubeb
		discord-rpc
		# Their build set up solely relies on the build in gtest.
		gtest
		# gentoo's version requires exception support.
		# dolphin disables exceptions and fails the build.
		picojson
	)
	local s
	for s in "${KEEP_SOURCES[@]}"; do
		mv -v "Externals/${s}" . || die
	done
	einfo "removing sources: $(echo Externals/*)"
	rm -r Externals/* || die "Failed to delete Externals dir."
	for s in "${KEEP_SOURCES[@]}"; do
		mv -v "${s}" "Externals/" || die
	done

	remove_locale() {
		# Ensure preservation of the backup locale when no valid LINGUA is set
		if [[ "${PLOCALE_BACKUP}" == "${1}" ]] && [[ "${PLOCALE_BACKUP}" == "$(l10n_get_locales)" ]]; then
			return
		else
			rm "Languages/po/${1}.po" || die
		fi
	}

	l10n_find_plocales_changes "Languages/po/" "" '.po'
	l10n_for_each_disabled_locale_do remove_locale
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SHARED_ENET=ON
		-DUSE_DISCORD_PRESENCE=$(usex discord-presence)
		-DENCODE_FRAMEDUMPS=$(usex ffmpeg)
		-DFASTLOG=$(usex log)
		-DOPROFILING=$(usex profile)

		-DENABLE_EVDEV=$(usex evdev)
		-DENABLE_LTO=$(usex lto)
		-DENABLE_QT=$(usex qt5)
		-DENABLE_SDL=$(usex sdl)

		-DUSE_EGL=$(usex egl)
		-DUSE_UPNP=$(usex upnp)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc Readme.md
	if use doc; then
		dodoc -r docs/ActionReplay docs/DSP docs/WiiMote
	fi

	doicon -s 48 Data/dolphin-emu.png
	doicon -s scalable Data/dolphin-emu.svg
	doicon Data/dolphin-emu.svg
}

pkg_postinst() {
	# Add pax markings for hardened systems
	pax-mark -m "${EPREFIX}"/usr/games/bin/"${PN}"-emu

	if ! use portaudio; then
		ewarn "If you want microphone capabilities in dolphin-emu, rebuild with"
		ewarn "USE=\"portaudio\""
	fi

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
