# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop flag-o-matic xdg-utils pax-utils

if [[ ${PV} == *9999 ]]
then
	EGIT_REPO_URI="https://github.com/dolphin-emu/dolphin"
	EGIT_SUBMODULES=( Externals/mGBA/mgba Externals/rcheevos/rcheevos )
	inherit git-r3
else
	EGIT_COMMIT=a68ae37df7168464459f395d2af3bee979a146ad
	FMT_COMMIT=e69e5f977d458f2650bb346dadf2ad30c5320281
	IMPLOT_COMMIT=cc5e1daa5c7f2335a9460ae79c829011dc5cef2d
	MGBA_COMMIT=8739b22fbc90fdf0b4f6612ef9c0520f0ba44a51
	MINIZIP_NG_COMMIT=3eed562ef0ea3516db30d1c8ecb0e1b486d8cb70
	RCHEEVOS_COMMIT=d54cf8f1059cebc90a6f5ecdf03df69259f22054
	TINYGLTF_COMMIT=c5641f2c22d117da7971504591a8f6a41ece488b
	VK_MEM_ALLOC_COMMIT=009ecd192c1289c7529bff248a16cfe896254816
	ZLIB_NG_COMMIT=ce01b1e41da298334f8214389cc9369540a7560f
	SRC_URI="
		https://github.com/dolphin-emu/dolphin/archive/${EGIT_COMMIT}.tar.gz
			-> ${P}.tar.gz
		https://github.com/fmtlib/fmt/archive/${FMT_COMMIT}.tar.gz -> fmt-${FMT_COMMIT}.tar.gz
		https://github.com/epezent/implot/archive/${IMPLOT_COMMIT}.tar.gz
			-> implot-${IMPLOT_COMMIT}.tar.gz
		https://github.com/zlib-ng/minizip-ng/archive/${MINIZIP_NG_COMMIT}.tar.gz
			-> minizip-ng-${MINIZIP_NG_COMMIT}.tar.gz
		https://github.com/RetroAchievements/rcheevos/archive/${RCHEEVOS_COMMIT}.tar.gz
			-> rcheevos-${RCHEEVOS_COMMIT}.tar.gz
		https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/archive/${VK_MEM_ALLOC_COMMIT}.tar.gz -> VulkanMemoryAllocator-${VK_MEM_ALLOC_COMMIT}.tar.gz
		https://github.com/syoyo/tinygltf/archive/${TINYGLTF_COMMIT}.tar.gz
			-> tinygltf-${TINYGLTF_COMMIT}.tar.gz
		https://github.com/zlib-ng/zlib-ng/archive/${ZLIB_NG_COMMIT}.tar.gz
			-> zlib-ng-${ZLIB_NG_COMMIT}.tar.gz
		mgba? (
			https://github.com/mgba-emu/mgba/archive/${MGBA_COMMIT}.tar.gz
				-> mgba-${MGBA_COMMIT}.tar.gz
		)
	"
	S=${WORKDIR}/${PN}-${EGIT_COMMIT}
	KEYWORDS="amd64 ~arm64"
fi

DESCRIPTION="Gamecube and Wii game emulator"
HOMEPAGE="https://dolphin-emu.org/"

LICENSE="GPL-2+ BSD BSD-2 LGPL-2.1+ MIT ZLIB"
SLOT="0"
IUSE="
	alsa bluetooth discord-presence doc +evdev ffmpeg +gui log mgba
	profile pulseaudio systemd test upnp vulkan
"

PATCHES=( "${FILESDIR}/${P}-system-libs.patch" )

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	app-arch/zstd:=
	dev-libs/hidapi:=
	dev-libs/lzo:=
	dev-libs/pugixml:=
	dev-libs/xxhash:=
	media-libs/cubeb:=
	media-libs/libglvnd:=
	media-libs/libpng:=
	media-libs/libsfml
	media-libs/libspng
	media-libs/mesa[egl(+)]
	net-libs/enet:1.3
	net-libs/mbedtls:=
	net-misc/curl:=
	sys-libs/readline:=
	x11-libs/libX11
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
		dev-qt/qtbase:6
		dev-qt/qtsvg:6
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
	[fmt]=MIT
	[imgui]=MIT
	[implot]=MIT
	[glslang]=BSD
	[tinygltf]=MIT
	[VulkanMemoryAllocator]=MIT
	# This needs minizip-ng[compat], which is masked in base profile.
	[minizip-ng]=ZLIB
	# zlib-ng[compat] is masked.
	[zlib-ng]=ZLIB

	[FreeSurround]=GPL-2+
	[soundtouch]=LGPL-2.1+

	# FIXME: discord-rpc not packaged
	[discord-rpc]=MIT

	[mGBA]=MPL-2.0

	[picojson]=BSD-2
	[expr]=MIT
	[rangeset]=ZLIB
	[FatFs]=BSD
	[rcheevos]=MIT
	[gtest]="" # (build-time only)
)

src_prepare() {
	if [[ ${PV} != *9999 ]]; then
		if use mgba; then
			rmdir Externals/mGBA/mgba || die
		mv "${WORKDIR}/mgba-${MGBA_COMMIT}" Externals/mGBA/mgba || die
		fi
		rmdir Externals/rcheevos/rcheevos || die
		mv "${WORKDIR}/rcheevos-${RCHEEVOS_COMMIT}" Externals/rcheevos/rcheevos || die
		rmdir Externals/implot/implot || die
		mv "${WORKDIR}/implot-${IMPLOT_COMMIT}" Externals/implot/implot || die
		rmdir Externals/zlib-ng/zlib-ng || die
		mv "${WORKDIR}/zlib-ng-${ZLIB_NG_COMMIT}" Externals/zlib-ng/zlib-ng || die
		rmdir Externals/VulkanMemoryAllocator || die
		mv "${WORKDIR}/VulkanMemoryAllocator-${VK_MEM_ALLOC_COMMIT}" Externals/VulkanMemoryAllocator || die
		rmdir Externals/fmt/fmt || die
		mv "${WORKDIR}/fmt-${FMT_COMMIT}" Externals/fmt/fmt || die
		rmdir Externals/minizip-ng/minizip-ng || die
		mv "${WORKDIR}/minizip-ng-${MINIZIP_NG_COMMIT}" Externals/minizip-ng/minizip-ng || die
		rmdir Externals/tinygltf/tinygltf || die
		mv "${WORKDIR}/tinygltf-${TINYGLTF_COMMIT}" Externals/tinygltf/tinygltf || die
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

	# Remove dirty suffix: needed for netplay
	sed -i -e 's/--dirty/&=""/' CMakeLists.txt || die
}

src_configure() {
	filter-lto # Likely the source of crash on launch with JIT enabled
	local mycmakeargs=(
		# Use ccache only when user did set FEATURES=ccache (or similar)
		# not when ccache binary is present in system (automagic).
		-DCCACHE_BIN=CCACHE_BIN-NOTFOUND
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_AUTOUPDATE=OFF
		-DENABLE_BLUEZ="$(usex bluetooth)"
		-DENABLE_EVDEV="$(usex evdev)"
		-DENCODE_FRAMEDUMPS="$(usex ffmpeg)"
		-DENABLE_LLVM=OFF
		# just adds -flto, user can do that via flags
		-DENABLE_LTO=OFF
		-DUSE_MGBA="$(usex mgba)"
		-DENABLE_PULSEAUDIO="$(usex pulseaudio)"
		-DENABLE_QT="$(usex gui)"
		-DENABLE_SDL=OFF # not supported: #666558
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_VULKAN="$(usex vulkan)"
		-DFASTLOG="$(usex log)"
		-DOPROFILING="$(usex profile)"
		-DUSE_DISCORD_PRESENCE="$(usex discord-presence)"
		-DUSE_UPNP="$(usex upnp)"
		-DUSE_RETRO_ACHIEVEMENTS=ON
		-DUSE_SYSTEM_MINIZIP=OFF

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
	pax-mark -m "${EPREFIX}/usr/games/bin/${PN}"-emu
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
