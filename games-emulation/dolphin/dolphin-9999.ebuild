# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="ar ca cs da de el en es fa fr hr hu it ja ko ms nb nl pl pt pt_BR ro ru sr sv tr zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit cmake desktop xdg-utils l10n pax-utils

if [[ ${PV} == *9999 ]]
then
	EGIT_REPO_URI="https://github.com/dolphin-emu/dolphin"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	inherit vcs-snapshot
	commit=0dbe8fb2eaa608a6540df3d269648a596c29cf4b
	SRC_URI="https://github.com/dolphin-emu/dolphin/archive/${commit}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Gamecube and Wii game emulator"
HOMEPAGE="https://www.dolphin-emu.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa bluetooth discord-presence doc +evdev ffmpeg log lto profile pulseaudio +qt5 systemd upnp vulkan"

RDEPEND="
	dev-libs/hidapi:0=
	>=dev-libs/libfmt-7.1:0=
	dev-libs/lzo:2=
	dev-libs/pugixml:0=
	media-libs/libpng:0=
	media-libs/libsfml
	media-libs/mesa[egl]
	net-libs/enet:1.3
	net-libs/mbedtls:0=
	net-misc/curl:0=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	virtual/libusb:1
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	bluetooth? ( net-wireless/bluez )
	evdev? (
		dev-libs/libevdev
		virtual/udev
	)
	ffmpeg? ( media-video/ffmpeg:= )
	profile? ( dev-util/oprofile )
	pulseaudio? ( media-sound/pulseaudio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	systemd? ( sys-apps/systemd:0= )
	upnp? ( net-libs/miniupnpc )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

# vulkan-loader required for vulkan backend which can be selected
# at runtime.
RDEPEND="${RDEPEND}
	vulkan? ( media-libs/vulkan-loader )"

src_prepare() {
	cmake_src_prepare

	# Remove all the bundled libraries that support system-installed
	# preference. See CMakeLists.txt for conditional 'add_subdirectory' calls.
	local KEEP_SOURCES=(
		Bochs_disasm
		FreeSurround

		# vulkan's API is not backwards-compatible:
		# new release dropped VK_PRESENT_MODE_RANGE_SIZE_KHR
		# but dolphin still relies on it, bug #729832
		Vulkan

		cpp-optparse
		# no support for for using system library
		glslang
		imgui

		# not packaged, tiny header library
		rangeset

		# FIXME: xxhash can't be found by cmake
		xxhash
		# no support for for using system library
		minizip
		# soundtouch uses shorts, not floats
		soundtouch
		cubeb
		discord-rpc
		# Their build set up solely relies on the build in gtest.
		gtest
		# gentoo's version requires exception support.
		# dolphin disables exceptions and fails the build.
		picojson
		# No code to detect shared library.
		zstd
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

	# About 50% compile-time speedup
	use vulkan || sed -i -e '/Externals\/glslang/d' CMakeLists.txt

	# Remove dirty suffix: needed for netplay
	sed -i -e 's/--dirty/&=""/' CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		# Use ccache only when user did set FEATURES=ccache (or similar)
		# not when ccache binary is present in system (automagic).
		-DCCACHE_BIN=CCACHE_BIN-NOTFOUND
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_BLUEZ=$(usex bluetooth)
		-DENABLE_EVDEV=$(usex evdev)
		-DENCODE_FRAMEDUMPS=$(usex ffmpeg)
		-DENABLE_LLVM=OFF
		-DENABLE_LTO=$(usex lto)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_QT=$(usex qt5)
		-DENABLE_SDL=OFF # not supported: #666558
		-DENABLE_VULKAN=$(usex vulkan)
		-DFASTLOG=$(usex log)
		-DOPROFILING=$(usex profile)
		-DUSE_DISCORD_PRESENCE=$(usex discord-presence)
		-DUSE_SHARED_ENET=ON
		-DUSE_UPNP=$(usex upnp)

		# Undo cmake-utils.eclass's defaults.
		# All dolphin's libraries are private
		# and rely on circular dependency resolution.
		-DBUILD_SHARED_LIBS=OFF

		# Avoid warning spam around unset variables.
		-Wno-dev
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

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
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
