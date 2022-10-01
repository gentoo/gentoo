# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"
inherit cmake fcaps flag-o-matic wxwidgets

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PCSX2/pcsx2.git"
else
	HASH_GLSLANG=c9706bdda0ac22b9856f1aa8261e5b9e15cd20c5
	HASH_VULKAN=9f4c61a31435a7a90a314fc68aeb386c92a09c0f
	SRC_URI="
		https://github.com/PCSX2/pcsx2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		vulkan? (
			https://github.com/KhronosGroup/glslang/archive/${HASH_GLSLANG}.tar.gz -> ${PN}-glslang-${HASH_GLSLANG::10}.tar.gz
			https://github.com/KhronosGroup/Vulkan-Headers/archive/${HASH_VULKAN}.tar.gz -> ${PN}-vulkan-headers-${HASH_VULKAN::10}.tar.gz
		)"
	KEYWORDS="-* ~amd64"
fi

DESCRIPTION="PlayStation 2 emulator"
HOMEPAGE="https://pcsx2.net/"

LICENSE="
	GPL-3+ Apache-2.0 BSD BSD-2 BSD-4 Boost-1.0 GPL-2+ ISC LGPL-2.1+
	LGPL-3+ MIT OFL-1.1 ZLIB public-domain"
SLOT="0"
# TODO: proper IUSE to handle cubeb backends with the now-required bundled copy
IUSE="cpu_flags_x86_sse4_1 pulseaudio qt6 test vulkan wayland"
REQUIRED_USE="cpu_flags_x86_sse4_1" # dies at runtime if no support
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/xz-utils
	app-arch/zstd:=
	dev-cpp/rapidyaml:=
	dev-libs/libaio
	dev-libs/libchdr
	>=dev-libs/libfmt-7.1.3:=
	dev-libs/libzip:=[zstd]
	media-libs/harfbuzz
	media-libs/libglvnd
	media-libs/libpng:=
	media-libs/libsamplerate
	>=media-libs/libsdl2-2.0.22[haptic,joystick]
	media-libs/libsoundtouch:=
	net-libs/libpcap
	sys-libs/zlib:=
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXrandr
	qt6? (
		dev-qt/qtbase:6[gui,network,widgets]
		dev-qt/qtsvg:6
		net-misc/curl
	)
	!qt6? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3[wayland?]
		x11-libs/wxGTK:${WX_GTK_VER}[X]
		pulseaudio? ( media-libs/libpulse )
	)
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	test? ( dev-cpp/gtest )"
BDEPEND="
	dev-lang/perl
	qt6? ( dev-qt/qttools[linguist] )
	!qt6? ( sys-devel/gettext )"

FILECAPS=(
	-m 0755 "CAP_NET_RAW+eip CAP_NET_ADMIN+eip" usr/bin/pcsx2
)

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-crcs.patch
	"${FILESDIR}"/${PN}-1.7.3329-lto.patch
	"${FILESDIR}"/${PN}-1.7.3329-musl.patch
	"${FILESDIR}"/${PN}-1.7.3329-qt6.patch
	"${FILESDIR}"/${PN}-1.7.3329-wx-vs-sdl.patch
	"${FILESDIR}"/${PN}-1.7.3351-unbundle.patch
)

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		local EGIT_SUBMODULES=()
		if use vulkan; then
			EGIT_SUBMODULES+=(
				3rdparty/glslang/glslang # needs StandAlone/ResourceLimits.h
				3rdparty/vulkan-headers # to keep in sync with glslang

				# system rapidyaml is still used, but this uses another part
				# of the source and so allow submodule for now
				# https://github.com/PCSX2/pcsx2/commit/af646e449
				3rdparty/rapidyaml/rapidyaml
				3rdparty/rapidyaml/rapidyaml/extern/c4core
				3rdparty/rapidyaml/rapidyaml/ext/c4core/src/c4/ext/fast_float

				# TODO?: check if easy to unbundle when look at next nightly bump
				# (there is a -DUSE_ACHIVEMENTS to be optional too)
				3rdparty/rcheevos/rcheevos
			)
		fi
		git-r3_src_unpack
	else
		default
		if use vulkan; then
			rmdir "${S}"/3rdparty/{glslang/glslang,vulkan-headers} || die
			mv glslang-${HASH_GLSLANG} "${S}"/3rdparty/glslang/glslang || die
			mv Vulkan-Headers-${HASH_VULKAN} "${S}"/3rdparty/vulkan-headers || die
		fi
	fi
}

src_prepare() {
	cmake_src_prepare

	# qt6 build doesn't support PACKAGE_MODE and need to set resources location
	sed -e "/EmuFolders::AppRoot =/s|=.*|= \"${EPREFIX}/usr/share/PCSX2\";|" \
		-i pcsx2/Frontend/CommonHost.cpp || die

	# pulseaudio is only used for usb-mic and without qt6, not for audio output
	{ use pulseaudio && use !qt6; } || :> cmake/FindPulseAudio.cmake || die

	# GS tests currently fail to build with qt6
	use !qt6 || sed -i '/add_subdirectory(GS)/d' tests/ctest/CMakeLists.txt || die

	if [[ ${PV} != 9999 ]]; then
		sed -e '/set(PCSX2_GIT_TAG "")/s/""/"v'${PV}'"/' \
			-i cmake/Pcsx2Utils.cmake || die

		# delete all 3rdparty/* except known-used ones in non-live
		local keep=(
			cpuinfo glad imgui include jpgd lzma simpleini xbyak
			$(usev vulkan 'glslang vulkan-headers')
		)
		find 3rdparty -mindepth 1 -maxdepth 1 -type d \
			-not \( -false ${keep[*]/#/-o -name } \) -exec rm -r {} + || die
	fi
}

src_configure() {
	use qt6 || setup-wxwidgets

	# for bundled glslang (bug #858374)
	use vulkan && append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=no
		-DDISABLE_BUILD_DATE=yes
		-DDISABLE_PCSX2_WRAPPER=yes
		-DDISABLE_SETCAP=yes
		-DENABLE_TESTS=$(usex test)
		-DPACKAGE_MODE=yes
		-DQT_BUILD=$(usex qt6)
		-DUSE_SYSTEM_LIBS=yes
		-DUSE_VTUNE=no
		-DUSE_VULKAN=$(usex vulkan)
		-DWAYLAND_API=$(usex wayland)
		-DXDG_STD=yes

		# sse4.1 is the bare minimum required, -m is required at build time
		# (see PCSX2Base.h) and it dies if no support at runtime (AppInit.cpp)
		# https://github.com/PCSX2/pcsx2/pull/4329
		-DARCH_FLAG=-msse4.1
	)

	cmake_src_configure
}

src_test() {
	cmake_build unittests
}

src_install() {
	cmake_src_install

	use qt6 && newbin "${BUILD_DIR}"/pcsx2-qt/pcsx2-qt pcsx2
}

pkg_postinst() {
	fcaps_pkg_postinst

	local replacing_old
	if [[ ${REPLACING_VERSIONS##* } ]] &&
		ver_test ${REPLACING_VERSIONS##* } -lt 1.6.1
	then
		replacing_old=
		elog ">=${PN}-1.7 has received several changes since <=${PN}-1.6.0, just-in-case"
		elog "it is recommended to backup your save states and memory cards before use."
		elog "Note that the executable was also renamed from 'PCSX2' to 'pcsx2'."
	fi

	if [[ ${PV} != 9999 && ( ! ${REPLACING_VERSIONS} || -v replacing_old ) ]]; then
		[[ -v replacing_old ]] && elog
		elog "${PN}-1.7.x is a development branch using a nightly release model"
		elog "(new 'release' every 1-2 days). Stable 1.6.0 is getting old and lacks"
		elog "many notable features (e.g. native 64bit builds). Given it may be a long"
		elog "time before there is a new stable, Gentoo will carry and update 1.7.x"
		elog "roughly every months."
		elog
		elog "Please report an issue if feel a picked nightly release needs to be"
		elog "updated ahead of time or masked (notably for handling regressions)."
	fi
}
