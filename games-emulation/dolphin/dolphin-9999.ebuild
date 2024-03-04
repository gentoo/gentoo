# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop flag-o-matic xdg-utils pax-utils

if [[ ${PV} == *9999 ]]
then
	EGIT_REPO_URI="https://github.com/dolphin-emu/dolphin"
	EGIT_SUBMODULES=( Externals/mGBA/mgba )
	inherit git-r3
else
	EGIT_COMMIT=0f2540a0d1133950467845f20b1e003181147781
	MGBA_COMMIT=40d4c430fc36caeb7ea32fd39624947ed487d2f2
	SRC_URI="
		https://github.com/dolphin-emu/dolphin/archive/${EGIT_COMMIT}.tar.gz
			-> ${P}.tar.gz
		mgba? (
			https://github.com/mgba-emu/mgba/archive/${MGBA_COMMIT}.tar.gz
				-> mgba-${MGBA_COMMIT}.tar.gz
		)
	"
	S=${WORKDIR}/${PN}-${EGIT_COMMIT}
	KEYWORDS="~amd64 ~arm64"
fi

DESCRIPTION="Gamecube and Wii game emulator"
HOMEPAGE="https://dolphin-emu.org/"

LICENSE="GPL-2+ BSD BSD-2 LGPL-2.1+ MIT ZLIB"
SLOT="0"
IUSE="
	alsa bluetooth discord-presence doc +evdev ffmpeg +gui log mgba
	profile pulseaudio systemd upnp vulkan
"

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	app-arch/zstd:=
	dev-libs/hidapi:=
	>=dev-libs/libfmt-8:=
	dev-libs/lzo:=
	dev-libs/pugixml:=
	media-libs/cubeb:=
	media-libs/libpng:=
	media-libs/libsfml:=
	media-libs/mesa[egl(+)]
	net-libs/enet:1.3
	net-libs/mbedtls:=
	net-misc/curl:=
	sys-libs/readline:=
	sys-libs/zlib:=[minizip]
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
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	profile? ( dev-util/oprofile )
	pulseaudio? ( media-libs/libpulse )
	systemd? ( sys-apps/systemd:0= )
	upnp? ( net-libs/miniupnpc )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

# vulkan-loader required for vulkan backend which can be selected
# at runtime.
RDEPEND+="
	vulkan? ( media-libs/vulkan-loader )
"

# [directory]=license
declare -A KEEP_BUNDLED=(
	# please keep this list in CMakeLists.txt order

	[Bochs_disasm]=LGPL-2.1+
	[cpp-optparse]=MIT
	[imgui]=MIT
	[glslang]=BSD

	# FIXME: xxhash can't be found by cmake
	[xxhash]=BSD-2

	# FIXME: requires minizip-ng
	#[minizip]=ZLIB

	[FreeSurround]=GPL-2+
	[soundtouch]=LGPL-2.1+

	# FIXME: discord-rpc not packaged
	[discord-rpc]=MIT

	[mGBA]=MPL-2.0

	[picojson]=BSD-2
	[rangeset]=ZLIB
	[gtest]= # (build-time only)
)

src_prepare() {
	if use mgba && [[ ${PV} != *9999 ]]; then
		rmdir Externals/mGBA/mgba || die
		mv "${WORKDIR}/mgba-${MGBA_COMMIT}" Externals/mGBA/mgba || die
	fi

	cmake_src_prepare

	local s remove=()
	for s in Externals/*; do
		[[ -f ${s} ]] && continue
		if ! has "${s#Externals/}" "${!KEEP_BUNDLED[@]}"; then
			remove+=( "${s}" )
		fi
	done

	einfo "removing sources: ${remove[*]}"
	rm -r "${remove[@]}" || die

	# About 50% compile-time speedup
	if ! use vulkan; then
		sed -i -e '/Externals\/glslang/d' CMakeLists.txt || die
	fi

	# Allow regular minizip.
	sed -i -e '/minizip/s:>=2[.]0[.]0::' CMakeLists.txt || die

	# Remove dirty suffix: needed for netplay
	sed -i -e 's/--dirty/&=""/' CMakeLists.txt || die

	# Force Qt5 rather than automagic until support is properly handled here
	sed -i -e '/NAMES Qt6 COMP/d' Source/Core/DolphinQt/CMakeLists.txt || die
}

src_configure() {
	# bug #891225 (https://bugs.dolphin-emu.org/issues/11481, QTBUG-61710)
	use gui && filter-lto

	local mycmakeargs=(
		# Use ccache only when user did set FEATURES=ccache (or similar)
		# not when ccache binary is present in system (automagic).
		-DCCACHE_BIN=CCACHE_BIN-NOTFOUND
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_AUTOUPDATE=OFF
		-DENABLE_BLUEZ=$(usex bluetooth)
		-DENABLE_EVDEV=$(usex evdev)
		-DENCODE_FRAMEDUMPS=$(usex ffmpeg)
		-DENABLE_LLVM=OFF
		# just adds -flto, user can do that via flags
		-DENABLE_LTO=OFF
		-DUSE_MGBA=$(usex mgba)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_QT=$(usex gui)
		-DENABLE_SDL=OFF # not supported: #666558
		-DENABLE_VULKAN=$(usex vulkan)
		-DFASTLOG=$(usex log)
		-DOPROFILING=$(usex profile)
		-DUSE_DISCORD_PRESENCE=$(usex discord-presence)
		-DUSE_SHARED_ENET=ON
		-DUSE_UPNP=$(usex upnp)

		# Undo cmake.eclass's defaults.
		# All dolphin's libraries are private
		# and rely on circular dependency resolution.
		-DBUILD_SHARED_LIBS=OFF

		# Avoid warning spam around unset variables.
		-Wno-dev
	)

	cmake_src_configure
}

src_test() {
	cmake_build unittests
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
