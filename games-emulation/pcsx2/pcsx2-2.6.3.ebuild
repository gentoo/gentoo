# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# note: keep old versions for an extended period (at "least" 2 months
# after stabilization unless it is broken) due to save states being
# locked to specific versions and users may need time

inherit cmake desktop eapi9-ver fcaps flag-o-matic optfeature toolchain-funcs

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
IUSE="alsa cpu_flags_x86_sse4_1 +clang jack pulseaudio sndio test wayland"
REQUIRED_USE="cpu_flags_x86_sse4_1" # dies at runtime if no support
RESTRICT="!test? ( test )"

# qtbase:6=[X] is due to using qtx11extras_p.h
# dlopen: libglvnd, qtsvg, shaderc, vulkan-loader, wayland
COMMON_DEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	dev-qt/qtbase:6=[X,concurrent,gui,widgets]
	dev-qt/qtsvg:6
	>=gui-libs/kddockwidgets-2.3:=
	media-libs/freetype
	media-libs/libglvnd[X]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsdl3
	media-libs/libwebp:=
	media-libs/plutosvg
	media-libs/plutovg
	media-libs/shaderc
	media-libs/vulkan-loader
	media-video/ffmpeg:=
	net-libs/libpcap
	net-misc/curl
	sys-apps/dbus
	virtual/zlib:=
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	pulseaudio? ( media-libs/libpulse )
	sndio? ( media-sound/sndio:= )
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
	clang? ( llvm-core/clang:* )
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.5232-cubeb-automagic.patch
	"${FILESDIR}"/${PN}-1.7.5835-musl-header.patch
	"${FILESDIR}"/${PN}-1.7.5913-musl-cache.patch
	"${FILESDIR}"/${PN}-2.5.317-flags.patch
)

CMAKE_QA_COMPAT_SKIP=1 #957976

src_prepare() {
	cmake_src_prepare

	if [[ ${PV} != 9999 ]]; then
		sed -e '/set(PCSX2_GIT_TAG "")/s/""/"v'${PV}'"/' \
			-i cmake/Pcsx2Utils.cmake || die
	fi

	# relax some version requirements which often get restricted without
	# a specific need, please report a bug to Gentoo (not upstream) if a
	# still-available older version is really causing issues
	sed -e '/find_package(\(Qt6\|SDL3\)/s/ [0-9.]* / /' \
		-i cmake/SearchForStuff.cmake || die

	# pluto(s)vg likewise often restrict versions and Gentoo also does not
	# have .pc files for it, use sed to avoid rebasing on version changes
	sed -e '/^find_package(plutovg/d' \
		-e '/^find_package(plutosvg/c\
			find_package(PkgConfig REQUIRED)\
			pkg_check_modules(plutovg REQUIRED IMPORTED_TARGET plutovg)\
			alias_library(plutovg::plutovg PkgConfig::plutovg)\
			pkg_check_modules(plutosvg REQUIRED IMPORTED_TARGET plutosvg)\
			alias_library(plutosvg::plutosvg PkgConfig::plutosvg)' \
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

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=no
		-DDISABLE_ADVANCE_SIMD=yes
		-DENABLE_TESTS=$(usex test)
		-DPACKAGE_MODE=yes
		-DUSE_BACKTRACE=no # not packaged (bug #885471)
		-DUSE_LINKED_FFMPEG=yes
		-DUSE_VTUNE=no # not packaged
		-DUSE_VULKAN=yes # currently fails to build without, may revisit
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

	newicon bin/resources/icons/AppIconLarge.png pcsx2.png
	make_desktop_entry pcsx2-qt PCSX2

	dodoc README.md bin/docs/GameIndex.pdf
}

pkg_postinst() {
	fcaps cap_net_admin,cap_net_raw=eip usr/bin/pcsx2-qt

	# calls aplay or gst-play/launch-1.0 as fallback
	# https://github.com/PCSX2/pcsx2/issues/11141
	optfeature "UI sound effects support" \
		media-sound/alsa-utils \
		media-libs/gst-plugins-base:1.0

	if ver_replacing -lt 2.2.0; then
		elog
		elog "Note that the 'pcsx2' executable was renamed to 'pcsx2-qt' with this version."
	fi
}
