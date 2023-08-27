# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop fcaps flag-o-matic

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PCSX2/pcsx2.git"
else
	# formerly was attempting to unbundle most, but upstream dropped every
	# checks for alternatively using system's and keeping this up has become
	# unmaintainable, and to simplify now also using tarballs with submodules
	SRC_URI="https://dev.gentoo.org/~ionen/distfiles/${P}.tar.xz"
	KEYWORDS="-* ~amd64"
fi

DESCRIPTION="PlayStation 2 emulator"
HOMEPAGE="https://pcsx2.net/"

LICENSE="
	GPL-3+ Apache-2.0 BSD BSD-2 BSD-4 Boost-1.0 CC0-1.0 GPL-2+
	ISC LGPL-2.1+ LGPL-3+ MIT OFL-1.1 ZLIB public-domain
"
SLOT="0"
IUSE="alsa cpu_flags_x86_sse4_1 dbus jack pulseaudio sndio test vulkan wayland"
REQUIRED_USE="cpu_flags_x86_sse4_1" # dies at runtime if no support
RESTRICT="!test? ( test )"

# dlopen: qtsvg, vulkan-loader, wayland
COMMON_DEPEND="
	app-arch/xz-utils
	dev-libs/libaio
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtsvg:6
	media-libs/libglvnd
	media-libs/libpng:=
	>=media-libs/libsdl2-2.28.2[haptic,joystick]
	media-video/ffmpeg:=
	net-libs/libpcap
	net-misc/curl
	sys-libs/zlib:=
	virtual/libudev:=
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	jack? ( virtual/jack )
	pulseaudio? ( media-libs/libpulse )
	sndio? ( media-sound/sndio:= )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
"
# patches is a optfeature but always pull given PCSX2 complaints if it
# is missing and it is fairly small (installs a ~1.5MB patches.zip)
RDEPEND="
	${COMMON_DEPEND}
	games-emulation/pcsx2_patches
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

FILECAPS=(
	-m 0755 "CAP_NET_RAW+eip CAP_NET_ADMIN+eip" usr/bin/pcsx2
)

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.3468-cubeb-automagic.patch
	"${FILESDIR}"/${PN}-1.7.3773-lto.patch
	"${FILESDIR}"/${PN}-1.7.4667-flags.patch
)

src_prepare() {
	cmake_src_prepare

	sed -e "/AppRoot =/s|=.*|= \"${EPREFIX}/usr/share/${PN}\";|" \
		-i pcsx2/Pcsx2Config.cpp || die

	if [[ ${PV} != 9999 ]]; then
		sed -e '/set(PCSX2_GIT_TAG "")/s/""/"v'${PV}-gentoo'"/' \
			-i cmake/Pcsx2Utils.cmake || die
	fi
}

src_configure() {
	if use vulkan; then
		# for bundled glslang (bug #858374)
		append-flags -fno-strict-aliasing

		# odr violations in pcsx2's vulkan code, disabling as a safety for now
		# (vulkan support tend to receive major changes, is more on WIP side)
		filter-lto
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=no
		-DDBUS_API=$(usex dbus)
		-DDISABLE_BUILD_DATE=yes
		-DENABLE_TESTS=$(usex test)
		-DUSE_LINKED_FFMPEG=yes
		-DUSE_VTUNE=no
		-DUSE_VULKAN=$(usex vulkan)
		-DWAYLAND_API=$(usex wayland)
		-DX11_API=yes # fails if X libs are missing even if disabled

		# sse4.1 is the bare minimum required, -m is required at build time
		# (see PCSX2Base.h) and it dies if no support at runtime (AppInit.cpp)
		# https://github.com/PCSX2/pcsx2/pull/4329
		-DARCH_FLAG=-msse4.1

		# not packaged due to bug #885471, but still disable for no automagic
		-DCMAKE_DISABLE_FIND_PACKAGE_Libbacktrace=yes

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
	newbin "${BUILD_DIR}"/bin/pcsx2-qt ${PN}

	insinto /usr/share/${PN}
	doins -r "${BUILD_DIR}"/bin/resources

	dodoc README.md bin/docs/{Debugger.pdf,GameIndex.pdf,debugger.txt}

	newicon bin/resources/icons/AppIconLarge.png ${PN}.png
	make_desktop_entry ${PN} ${PN^^}
}

pkg_postinst() {
	fcaps_pkg_postinst

	local replacing=
	if [[ ${REPLACING_VERSIONS##* } ]]; then
		if ver_test ${REPLACING_VERSIONS##* } -lt 1.6.1; then
			replacing=old
		elif ver_test ${REPLACING_VERSIONS##* } -lt 1.7.3773; then
			replacing=wx
		else
			replacing=any
		fi
	fi

	if [[ ${replacing} == old ]]; then
		elog
		elog ">=${PN}-1.7 has received several changes since <=${PN}-1.6.0, notably"
		elog "it is now a 64bit build using Qt6. Just-in-case it is recommended to"
		elog "backup your configs, save states, and memory cards before use."
		elog "The executable was also renamed from 'PCSX2' to 'pcsx2'."
	fi

	if [[ ${replacing} == @(|old) && ${PV} != 9999 ]]; then
		elog
		elog "${PN}-1.7.x is a development branch where .x increments every changes."
		elog "Stable 1.6.0 is getting old and lacks many notable features (e.g. native"
		elog "64bit builds). Given it may be a long time before there is a new stable,"
		elog "Gentoo will carry and update 1.7.x roughly every months."
		elog
		elog "Please report an issue if feel a picked version needs to be updated ahead"
		elog "of time or masked (notably for handling regressions)."
	fi

	if [[ ${replacing} == wx ]]; then
		ewarn
		ewarn "Note that wxGTK support been dropped upstream since >=${PN}-1.7.3773,"
		ewarn "and so USE=qt6 is gone and Qt6 is now always used."
	fi
}
