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
IUSE="alsa cpu_flags_x86_sse4_1 jack pulseaudio sndio test vulkan wayland"
REQUIRED_USE="cpu_flags_x86_sse4_1" # dies at runtime if no support
RESTRICT="!test? ( test )"

# dlopen: qtsvg, vulkan-loader, wayland
COMMON_DEPEND="
	app-arch/xz-utils
	dev-libs/libaio
	>=dev-qt/qtbase-6.6.0:6[gui,widgets]
	>=dev-qt/qtsvg-6.6.0:6
	media-libs/libglvnd
	media-libs/libpng:=
	>=media-libs/libsdl2-2.28.4[haptic,joystick]
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
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
"
# patches is a optfeature but always pull given PCSX2 complaints if it
# is missing and it is fairly small (installs a ~1.5MB patches.zip)
RDEPEND="
	${COMMON_DEPEND}
	>=games-emulation/pcsx2_patches-0_p20230917
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	>=dev-qt/qttools-6.6.0:6[linguist]
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.3773-lto.patch
	"${FILESDIR}"/${PN}-1.7.4667-flags.patch
	"${FILESDIR}"/${PN}-1.7.5232-cubeb-automagic.patch
)

src_prepare() {
	cmake_src_prepare

	if [[ ${PV} != 9999 ]]; then
		sed -e '/set(PCSX2_GIT_TAG "")/s/""/"v'${PV}'"/' \
			-i cmake/Pcsx2Utils.cmake || die
	fi
}

src_configure() {
	if use vulkan; then
		# for bundled glslang (bug #858374)
		append-flags -fno-strict-aliasing

		# odr violations in pcsx2's vulkan code, disabling as a safety for now
		filter-lto
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=no
		-DDISABLE_BUILD_DATE=yes
		-DENABLE_TESTS=$(usex test)
		-DUSE_LINKED_FFMPEG=yes
		-DUSE_VTUNE=no
		-DUSE_VULKAN=$(usex vulkan)
		-DWAYLAND_API=$(usex wayland)
		-DX11_API=yes # X libs are currently hard-required either way

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
	insinto /usr/lib/${PN}
	doins -r "${BUILD_DIR}"/bin/.

	fperms +x /usr/lib/${PN}/pcsx2-qt
	dosym -r /usr/lib/${PN}/pcsx2-qt /usr/bin/${PN}

	newicon bin/resources/icons/AppIconLarge.png ${PN}.png
	make_desktop_entry ${PN} ${PN^^}

	dodoc README.md bin/docs/{Debugger.pdf,GameIndex.pdf,debugger.txt}

	use !test || rm "${ED}"/usr/lib/${PN}/*_test || die
}

pkg_postinst() {
	fcaps -m 0755 cap_net_admin,cap_net_raw=eip usr/lib/${PN}/pcsx2-qt

	if [[ ${REPLACING_VERSIONS##* } ]] &&
		ver_test ${REPLACING_VERSIONS##* } -lt 1.7; then
		elog ">=${PN}-1.7 has received several changes since <=${PN}-1.6.0, and is"
		elog "notably now a 64bit build using Qt6. Just-in-case it is recommended"
		elog "to backup configs, save states, and memory cards before using."
		elog
		elog "The executable was also renamed from 'PCSX2' to 'pcsx2'."
	fi
}
