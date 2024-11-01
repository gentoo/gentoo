# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop fcaps flag-o-matic optfeature toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PCSX2/pcsx2.git"
else
	SRC_URI="
		https://github.com/PCSX2/pcsx2/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz
	"
	KEYWORDS="-* ~amd64"
fi

DESCRIPTION="PlayStation 2 emulator"
HOMEPAGE="https://pcsx2.net/"

LICENSE="
	GPL-3+ Apache-2.0 BSD BSD-2 BSD-4 Boost-1.0 CC0-1.0 GPL-2+
	ISC LGPL-2.1+ LGPL-3+ MIT OFL-1.1 ZLIB public-domain
"
SLOT="0"
IUSE="alsa cpu_flags_x86_sse4_1 +clang jack pulseaudio sndio test vulkan wayland"
REQUIRED_USE="cpu_flags_x86_sse4_1" # dies at runtime if no support
RESTRICT="!test? ( test )"

# dlopen: libglvnd, qtsvg, shaderc, vulkan-loader, wayland
COMMON_DEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	dev-qt/qtbase:6[concurrent,gui,widgets]
	dev-qt/qtsvg:6
	media-libs/freetype
	media-libs/libglvnd[X]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsdl2[haptic,joystick]
	media-libs/libwebp:=
	media-video/ffmpeg:=
	net-libs/libpcap
	net-misc/curl
	sys-apps/dbus
	sys-libs/zlib:=
	virtual/libudev:=
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	pulseaudio? ( media-libs/libpulse )
	sndio? ( media-sound/sndio:= )
	vulkan? (
		media-libs/shaderc
		media-libs/vulkan-loader
	)
	wayland? ( dev-libs/wayland )
"
# patches is a optfeature but always pull given PCSX2 complaints if it
# is missing and it is fairly small (installs a ~1.5MB patches.zip)
RDEPEND="
	${COMMON_DEPEND}
	>=games-emulation/pcsx2_patches-0_p20241020
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	clang? ( sys-devel/clang:* )
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.4667-flags.patch
	"${FILESDIR}"/${PN}-1.7.5232-cubeb-automagic.patch
	"${FILESDIR}"/${PN}-1.7.5835-vanilla-shaderc.patch
	"${FILESDIR}"/${PN}-1.7.5835-musl-header.patch
	"${FILESDIR}"/${PN}-1.7.5913-musl-cache.patch
	"${FILESDIR}"/${PN}-2.2.0-missing-header.patch
)

src_prepare() {
	cmake_src_prepare

	if [[ ${PV} != 9999 ]]; then
		sed -e '/set(PCSX2_GIT_TAG "")/s/""/"v'${PV}'"/' \
			-i cmake/Pcsx2Utils.cmake || die
	fi

	# relax Qt6 and SDL2 version requirements which often get restricted
	# without a specific need, please report a bug to Gentoo (not upstream)
	# if a still-available older version is really causing issues
	sed -e '/find_package(\(Qt6\|SDL2\)/s/ [0-9.]*//' \
		-i cmake/SearchForStuff.cmake || die
}

src_configure() {
	# note that upstream only supports clang and ignores gcc issues, e.g.
	# https://github.com/PCSX2/pcsx2/issues/10624#issuecomment-1890326047
	# (CMakeLists.txt also gives a big warning if compiler is not clang)
	if use clang && ! tc-is-clang; then
		local -x CC=${CHOST}-clang CXX=${CHOST}-clang++
		strip-unsupported-flags
	fi

	# pthread_attr_setaffinity_np is not supported on musl, may be possible
	# to remove if bundled lzma code is updated like 7zip did (bug #935298)
	use elibc_musl && append-cppflags -DZ7_AFFINITY_DISABLE

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=no
		-DDISABLE_ADVANCE_SIMD=yes
		-DENABLE_TESTS=$(usex test)
		-DPACKAGE_MODE=yes
		-DUSE_BACKTRACE=no # not packaged (bug #885471)
		-DUSE_LINKED_FFMPEG=yes
		-DUSE_VTUNE=no # not packaged
		-DUSE_VULKAN=$(usex vulkan)

		# note that upstream hardly support native wayland, may or may not work
		# https://github.com/PCSX2/pcsx2/pull/10179
		-DWAYLAND_API=$(usex wayland)
		# not optional given libX11 is hard-required either way and upstream
		# seemingly has no intention to drop the requirement at the moment
		# https://github.com/PCSX2/pcsx2/issues/11149
		-DX11_API=yes

		# bundled cubeb flags, see media-libs/cubeb and cubeb-automagic.patch
		-DCHECK_ALSA=$(usex alsa)
		-DCHECK_JACK=$(usex jack)
		-DCHECK_PULSE=$(usex pulseaudio)
		-DCHECK_SNDIO=$(usex sndio)
		-DLAZY_LOAD_LIBS=no
	)

	cmake_src_configure
}

src_test() {
	cmake_build unittests
}

src_install() {
	cmake_src_install

	newicon bin/resources/icons/AppIconLarge.png pcsx2-qt.png
	make_desktop_entry pcsx2-qt PCSX2

	dodoc README.md bin/docs/{Debugger.pdf,GameIndex.pdf,debugger.txt}
}

pkg_postinst() {
	fcaps -m 0755 cap_net_admin,cap_net_raw=eip usr/bin/pcsx2-qt

	# calls aplay or gst-play/launch-1.0 as fallback
	# https://github.com/PCSX2/pcsx2/issues/11141
	optfeature "UI sound effects support" \
		media-sound/alsa-utils \
		media-libs/gst-plugins-base:1.0

	if [[ ${REPLACING_VERSIONS##* } ]] &&
		ver_test ${REPLACING_VERSIONS##* } -lt 2.2.0
	then
		elog
		elog "Note that the 'pcsx2' executable was renamed to 'pcsx2-qt' with this version."
	fi
}
