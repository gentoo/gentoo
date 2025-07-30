# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {18..20} )
LLVM_OPTIONAL=1

inherit cmake llvm-r1 pax-utils xdg-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dolphin-emu/dolphin"
	EGIT_SUBMODULES=(
		Externals/mGBA/mgba
		Externals/implot/implot
		Externals/tinygltf/tinygltf
		Externals/Vulkan-Headers
		Externals/VulkanMemoryAllocator
		Externals/zlib-ng/zlib-ng
		Externals/minizip-ng/minizip-ng
	)
else
	MGBA_COMMIT=8739b22fbc90fdf0b4f6612ef9c0520f0ba44a51
	IMPLOT_COMMIT=18c72431f8265e2b0b5378a3a73d8a883b2175ff
	TINYGLTF_COMMIT=c5641f2c22d117da7971504591a8f6a41ece488b
	VULKAN_HEADERS_COMMIT=39f924b810e561fd86b2558b6711ca68d4363f68
	VULKANMEMORYALLOCATOR_COMMIT=3bab6924988e5f19bf36586a496156cf72f70d9f
	ZLIB_NG_COMMIT=ce01b1e41da298334f8214389cc9369540a7560f
	MINIZIP_NG_COMMIT=55db144e03027b43263e5ebcb599bf0878ba58de
	SRC_URI="
		https://github.com/dolphin-emu/dolphin/archive/${PV}.tar.gz
			-> ${P}.tar.gz
		https://github.com/epezent/implot/archive/${IMPLOT_COMMIT}.tar.gz
			-> implot-${IMPLOT_COMMIT}.tar.gz
		https://github.com/syoyo/tinygltf/archive/${TINYGLTF_COMMIT}.tar.gz
			-> tinygltf-${TINYGLTF_COMMIT}.tar.gz
		https://github.com/KhronosGroup/Vulkan-Headers/archive/${VULKAN_HEADERS_COMMIT}.tar.gz
			-> Vulkan-Headers-${VULKAN_HEADERS_COMMIT}.tar.gz
		https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/archive/${VULKANMEMORYALLOCATOR_COMMIT}.tar.gz
			-> VulkanMemoryAllocator-${VULKANMEMORYALLOCATOR_COMMIT}.tar.gz
		https://github.com/zlib-ng/zlib-ng/archive/${ZLIB_NG_COMMIT}.tar.gz
			-> zlib-ng-${ZLIB_NG_COMMIT}.tar.gz
		https://github.com/zlib-ng/minizip-ng/archive/${MINIZIP_NG_COMMIT}.tar.gz
			-> minizip-ng-${MINIZIP_NG_COMMIT}.tar.gz
		mgba? (
			https://github.com/mgba-emu/mgba/archive/${MGBA_COMMIT}.tar.gz
				-> mgba-${MGBA_COMMIT}.tar.gz
		)
	"
	KEYWORDS="amd64 ~arm64"
fi

DESCRIPTION="Gamecube and Wii game emulator"
HOMEPAGE="https://dolphin-emu.org/"

LICENSE="GPL-2+ BSD BSD-2 LGPL-2.1+ MIT ZLIB"
SLOT="0"
IUSE="
	alsa bluetooth discord-presence doc egl +evdev ffmpeg +gui llvm log mgba
	profile pulseaudio sdl systemd telemetry test upnp vulkan
"
REQUIRED_USE="
	mgba? ( gui )
	llvm? ( ${LLVM_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2:=
	>=app-arch/lz4-1.8:=
	app-arch/xz-utils
	>=app-arch/zstd-1.4.0:=
	dev-libs/hidapi
	>=dev-libs/libfmt-10.1:=
	dev-libs/lzo:2
	dev-libs/pugixml
	dev-libs/xxhash
	media-libs/cubeb
	>=media-libs/libsfml-3.0:=
	media-libs/libspng
	>=net-libs/enet-1.3.18:1.3=
	net-libs/mbedtls:0=
	net-misc/curl
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
	virtual/libusb:1
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	bluetooth? ( net-wireless/bluez:= )
	evdev? (
		dev-libs/libevdev
		virtual/libudev
	)
	ffmpeg? ( media-video/ffmpeg:= )
	gui? (
		dev-qt/qtbase:6[X,gui,widgets]
		dev-qt/qtsvg:6
	)
	llvm? ( $(llvm_gen_dep 'llvm-core/llvm:${LLVM_SLOT}=') )
	profile? ( dev-util/oprofile )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( >=media-libs/libsdl2-2.30.9 )
	systemd? ( sys-apps/systemd:0= )
	upnp? ( net-libs/miniupnpc:= )
"
DEPEND="
	${RDEPEND}
	egl? ( media-libs/libglvnd )
	test? ( dev-cpp/gtest )
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

	# TODO: use system libraries
	# bug #873952
	# https://github.com/dolphin-emu/dolphin/pull/13089
	[zlib-ng]=ZLIB
	[minizip-ng]=ZLIB

	[Bochs_disasm]=LGPL-2.1+
	[cpp-optparse]=MIT
	[imgui]=MIT
	[implot]=MIT
	[glslang]=BSD

	[tinygltf]=MIT

	[FreeSurround]=GPL-2+
	[soundtouch]=LGPL-2.1+

	# FIXME: discord-rpc not packaged
	[discord-rpc]=MIT

	[mGBA]=MPL-2.0

	[picojson]=BSD-2
	[expr]=MIT
	[rangeset]=ZLIB
	[FatFs]=FatFs
	[Vulkan-Headers]="|| ( Apache-2.0 MIT )"
	[VulkanMemoryAllocator]=MIT
)

PATCHES=(
	"${FILESDIR}"/dolphin-2407-minizip.patch
)

add_bundled_licenses() {
	for license in ${KEEP_BUNDLED[@]}; do
		LICENSE+=" ${license}"
	done
}
add_bundled_licenses

pkg_setup() {
	use llvm && llvm-r1_pkg_setup
}

src_prepare() {
	if [[ ${PV} != *9999 ]]; then
		mv -T "${WORKDIR}/implot-${IMPLOT_COMMIT}" Externals/implot/implot || die
		mv -T "${WORKDIR}/tinygltf-${TINYGLTF_COMMIT}" Externals/tinygltf/tinygltf || die
		mv -T "${WORKDIR}/Vulkan-Headers-${VULKAN_HEADERS_COMMIT}" Externals/Vulkan-Headers || die
		mv -T "${WORKDIR}/VulkanMemoryAllocator-${VULKANMEMORYALLOCATOR_COMMIT}" Externals/VulkanMemoryAllocator || die
		mv -T "${WORKDIR}/zlib-ng-${ZLIB_NG_COMMIT}" Externals/zlib-ng/zlib-ng || die
		mv -T "${WORKDIR}/minizip-ng-${MINIZIP_NG_COMMIT}" Externals/minizip-ng/minizip-ng || die
		if use mgba; then
			mv -T "${WORKDIR}/mgba-${MGBA_COMMIT}" Externals/mGBA/mgba || die
		fi
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

	# Remove dirty suffix: needed for netplay
	sed -i -e 's/--dirty/&=""/' CMake/ScmRevGen.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DDSPTOOL=ON
		-DENABLE_ALSA=$(usex alsa)
		-DENABLE_ANALYTICS=$(usex telemetry)
		-DENABLE_AUTOUPDATE=OFF
		-DENABLE_BLUEZ=$(usex bluetooth)
		-DENABLE_CLI_TOOL=ON
		-DENABLE_CUBEB=ON
		-DENABLE_EGL=$(usex egl)
		-DENABLE_EVDEV=$(usex evdev)
		-DENABLE_HWDB=$(usex evdev)
		-DENABLE_LLVM=$(usex llvm)
		-DENABLE_LTO=OFF # just adds -flto, user can do that via flags
		-DENABLE_NOGUI=$(usex !gui)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio)
		-DENABLE_QT=$(usex gui)
		-DENABLE_SDL=$(usex sdl)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_VULKAN=$(usex vulkan)
		-DENCODE_FRAMEDUMPS=$(usex ffmpeg)
		-DFASTLOG=$(usex log)
		-DOPROFILING=$(usex profile)
		-DUSE_DISCORD_PRESENCE=$(usex discord-presence)
		-DUSE_MGBA=$(usex mgba)
		-DUSE_RETRO_ACHIEVEMENTS=OFF
		-DUSE_UPNP=$(usex upnp)

		-DCMAKE_DISABLE_FIND_PACKAGE_SYSTEMD=$(usex !systemd)

		# Use system libraries
		-DUSE_SYSTEM_FMT=ON
		-DUSE_SYSTEM_PUGIXML=ON
		-DUSE_SYSTEM_ENET=ON
		-DUSE_SYSTEM_XXHASH=ON
		-DUSE_SYSTEM_BZIP2=ON
		-DUSE_SYSTEM_LIBLZMA=ON
		-DUSE_SYSTEM_ZSTD=ON
		-DUSE_SYSTEM_MINIZIP=OFF
		-DUSE_SYSTEM_LZO=ON
		-DUSE_SYSTEM_LZ4=ON
		-DUSE_SYSTEM_SPNG=ON
		-DUSE_SYSTEM_CUBEB=ON
		-DUSE_SYSTEM_LIBUSB=ON
		-DUSE_SYSTEM_SFML=ON
		-DUSE_SYSTEM_MBEDTLS=ON
		-DUSE_SYSTEM_CURL=ON
		-DUSE_SYSTEM_ICONV=ON
		-DUSE_SYSTEM_HIDAPI=ON

		# Use ccache only when user did set FEATURES=ccache (or similar)
		# not when ccache binary is present in system (automagic).
		-DCCACHE_BIN=CCACHE_BIN-NOTFOUND

		# Undo cmake.eclass's defaults.
		# All dolphin's libraries are private
		# and rely on circular dependency resolution.
		-DBUILD_SHARED_LIBS=OFF

		# Avoid warning spam around unset variables.
		-Wno-dev
	)

	# System installed git shouldnt affect non live builds
	[[ ${PV} != *9999 ]] && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Git=ON )

	use test && mycmakeargs+=( -DUSE_SYSTEM_GTEST=ON )
	use mgba && mycmakeargs+=( -DUSE_SYSTEM_LIBMGBA=OFF )
	use sdl && mycmakeargs+=( -DUSE_SYSTEM_SDL2=ON )
	use upnp && mycmakeargs+=( -DUSE_SYSTEM_MINIUPNPC=ON )

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

	# Add pax markings for hardened systems
	pax-mark -m "${ED}"/usr/bin/"${PN}"{-emu{,-nogui},-tool}
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
