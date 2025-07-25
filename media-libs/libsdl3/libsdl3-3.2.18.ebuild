# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib dot-a

DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://www.libsdl.org/"
SRC_URI="https://www.libsdl.org/release/SDL3-${PV}.tar.gz"
S=${WORKDIR}/SDL3-${PV}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"

IUSE="
	X alsa aqua dbus doc ibus io-uring jack kms opengl oss pipewire
	pulseaudio sndio test udev usb vulkan wayland
	cpu_flags_ppc_altivec cpu_flags_x86_avx cpu_flags_x86_avx2
	cpu_flags_x86_avx512f cpu_flags_x86_mmx cpu_flags_x86_sse
	cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_sse4_1
	cpu_flags_x86_sse4_2
"
REQUIRED_USE="
	ibus? ( dbus )
	kms? ( opengl )
	wayland? ( opengl )
"
RESTRICT="!test? ( test )"

# dlopen/dbus-only: dbus, ibus, libudev, liburing, vulkan-loader
RDEPEND="
	virtual/libiconv[${MULTILIB_USEDEP}]
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXScrnSaver[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
	)
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	ibus? ( app-i18n/ibus )
	io-uring? ( sys-libs/liburing:=[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	kms? (
		media-libs/mesa[gbm(+),${MULTILIB_USEDEP}]
		x11-libs/libdrm[${MULTILIB_USEDEP}]
	)
	opengl? ( media-libs/libglvnd[X?,${MULTILIB_USEDEP}] )
	pipewire? ( media-video/pipewire:=[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	sndio? ( media-sound/sndio:=[${MULTILIB_USEDEP}] )
	udev? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	usb? ( virtual/libusb:1[${MULTILIB_USEDEP}] )
	wayland? (
		dev-libs/wayland[${MULTILIB_USEDEP}]
		gui-libs/libdecor[${MULTILIB_USEDEP}]
		x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	)
	vulkan? ( media-libs/vulkan-loader[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
	test? (
		dev-util/vulkan-headers
		media-libs/libglvnd
	)
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	wayland? ( dev-util/wayland-scanner )
"

src_prepare() {
	cmake_src_prepare

	# unbundle libglvnd and vulkan headers
	rm -r src/video/khronos || die
	ln -s -- "${ESYSROOT}"/usr/include src/video/khronos || die
}

src_configure() {
	lto-guarantee-fat

	local mycmakeargs=(
		-DSDL_ASSERTIONS=disabled
		-DSDL_DBUS=$(usex dbus)
		-DSDL_DEPS_SHARED=no # link rather than dlopen() where possible
		-DSDL_LIBURING=$(usex io-uring)
		-DSDL_RPATH=no
		-DSDL_STATIC=no
		-DSDL_TESTS=$(usex test)

		# audio
		-DSDL_ALSA=$(usex alsa)
		-DSDL_JACK=$(usex jack)
		-DSDL_OSS=$(usex oss)
		-DSDL_PIPEWIRE=$(usex pipewire)
		-DSDL_PULSEAUDIO=$(usex pulseaudio)
		-DSDL_SNDIO=$(usex sndio)

		# input
		-DSDL_HIDAPI_LIBUSB=$(usex usb)
		-DSDL_IBUS=$(use ibus)
		-DSDL_LIBUDEV=$(usex udev)

		# video
		-DSDL_COCOA=$(usex aqua)
		-DSDL_DIRECTX=no
		-DSDL_KMSDRM=$(usex kms)
		-DSDL_OPENGL=$(usex opengl)
		-DSDL_OPENGLES=$(usex opengl)
		-DSDL_OPENVR=$(usex opengl) # only dependency is libglvnd
		-DSDL_ROCKCHIP=no
		-DSDL_RPI=no
		-DSDL_VIVANTE=no
		-DSDL_VULKAN=$(usex vulkan)
		-DSDL_WAYLAND=$(usex wayland)
		-DSDL_X11=$(usex X)
		# SDL disallows this by default, allow it but warn in pkg_postinst
		$(use !X && use !wayland && echo -DSDL_UNIX_CONSOLE_BUILD=yes)

		# cpu instruction sets
		-DSDL_ALTIVEC=$(usex cpu_flags_ppc_altivec)
		-DSDL_AVX=$(usex cpu_flags_x86_avx)
		-DSDL_AVX2=$(usex cpu_flags_x86_avx2)
		-DSDL_AVX512F=$(usex cpu_flags_x86_avx512f)
		-DSDL_MMX=$(usex cpu_flags_x86_mmx)
		-DSDL_SSE=$(usex cpu_flags_x86_sse)
		-DSDL_SSE2=$(usex cpu_flags_x86_sse2)
		-DSDL_SSE3=$(usex cpu_flags_x86_sse3)
		-DSDL_SSE4_1=$(usex cpu_flags_x86_sse4_1)
		-DSDL_SSE4_2=$(usex cpu_flags_x86_sse4_2)
	)

	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile

	if use doc; then
		cd docs && doxygen || die
	fi
}

src_test() {
	unset "${!SDL_@}" # ignore users' preferences for tests

	cmake-multilib_src_test
}

src_install() {
	local DOCS=( {BUGS,WhatsNew}.txt {CREDITS,README}.md docs/*.md )
	cmake-multilib_src_install

	strip-lto-bytecode

	rm -r -- "${ED}"/usr/share/licenses || die

	use doc && dodoc -r docs/output/html/
}

pkg_postinst() {
	# skipping audio/video can make sense given many packages only use SDL
	# for input, but still warn given off-by-default and may be unexpected
	if use !X && use !aqua && use !kms && use !wayland; then
		ewarn
		ewarn "All typical display drivers (e.g. USE=wayland) are disabled,"
		ewarn "applications using SDL for display may not function properly."
	fi

	if use !alsa && use !jack && use !oss && use !pipewire &&
		use !pulseaudio && use !sndio; then
		ewarn
		ewarn "All typical audio drivers (e.g. USE=pipewire) are disabled,"
		ewarn "applications using SDL for audio may not function properly."
	fi
}
