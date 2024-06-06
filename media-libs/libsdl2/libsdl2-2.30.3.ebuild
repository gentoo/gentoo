# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

MY_P="SDL2-${PV}"
DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://www.libsdl.org/"
SRC_URI="https://www.libsdl.org/release/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="alsa aqua cpu_flags_ppc_altivec cpu_flags_x86_3dnow cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 custom-cflags dbus doc fcitx4 gles1 gles2 +haptic ibus jack +joystick kms libsamplerate nas opengl oss pipewire pulseaudio sndio +sound static-libs test +threads udev +video vulkan wayland X xscreensaver"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	alsa? ( sound )
	fcitx4? ( dbus )
	gles1? ( video )
	gles2? ( video )
	haptic? ( joystick )
	ibus? ( dbus )
	jack? ( sound )
	nas? ( sound )
	opengl? ( video )
	pulseaudio? ( sound )
	sndio? ( sound )
	test? ( static-libs )
	vulkan? ( video )
	wayland? ( gles2 )
	xscreensaver? ( X )
"

COMMON_DEPEND="
	virtual/libiconv[${MULTILIB_USEDEP}]
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	ibus? ( app-i18n/ibus )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	kms? (
		>=x11-libs/libdrm-2.4.82[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.0.0[${MULTILIB_USEDEP},gbm(+)]
	)
	libsamplerate? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
	nas? (
		>=media-libs/nas-1.9.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
	)
	pipewire? ( media-video/pipewire:=[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	sndio? ( media-sound/sndio:=[${MULTILIB_USEDEP}] )
	udev? ( >=virtual/libudev-208:=[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.20[${MULTILIB_USEDEP}]
		gui-libs/libdecor[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.1.6[${MULTILIB_USEDEP},egl(+),gles2(+),wayland]
		>=x11-libs/libxkbcommon-0.2.0[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-1.1.14[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-6.0.0[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		xscreensaver? ( >=x11-libs/libXScrnSaver-1.2.2-r1[${MULTILIB_USEDEP}] )
	)
"
RDEPEND="
	${COMMON_DEPEND}
	fcitx4? ( app-i18n/fcitx:4 )
	gles1? ( media-libs/mesa[${MULTILIB_USEDEP},gles1(+)] )
	gles2? ( media-libs/mesa[${MULTILIB_USEDEP},gles2(+)] )
	vulkan? ( media-libs/vulkan-loader )
"
DEPEND="
	${COMMON_DEPEND}
	gles1? ( media-libs/libglvnd )
	gles2? ( media-libs/libglvnd )
	ibus? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )
	test? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
	vulkan? ( dev-util/vulkan-headers )
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	wayland? ( >=dev-util/wayland-scanner-1.20 )
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/SDL2/SDL_config.h
	/usr/include/SDL2/SDL_platform.h
	/usr/include/SDL2/begin_code.h
	/usr/include/SDL2/close_code.h
)

src_prepare() {
	cmake_src_prepare

	# Unbundle some headers.
	rm -r src/video/khronos || die
	ln -s "${ESYSROOT}/usr/include" src/video/khronos || die
}

src_configure() {
	use custom-cflags || strip-flags

	local mycmakeargs=(
		-DSDL_STATIC=$(usex static-libs)
		-DSDL_SYSTEM_ICONV=ON
		-DSDL_GCC_ATOMICS=ON
		-DSDL_AUDIO=$(usex sound)
		-DSDL_VIDEO=$(usex video)
		-DSDL_JOYSTICK=$(usex joystick)
		-DSDL_HAPTIC=$(usex haptic)
		-DSDL_POWER=ON
		-DSDL_FILESYSTEM=ON
		-DSDL_PTHREADS=$(usex threads)
		-DSDL_TIMERS=ON
		-DSDL_FILE=ON
		-DSDL_LOADSO=ON
		-DSDL_ASSEMBLY=ON
		-DSDL_ALTIVEC=$(usex cpu_flags_ppc_altivec)
		-DSDL_SSEMATH=$(usex cpu_flags_x86_sse)
		-DSDL_MMX=$(usex cpu_flags_x86_mmx)
		-DSDL_3DNOW=$(usex cpu_flags_x86_3dnow)
		-DSDL_SSE=$(usex cpu_flags_x86_sse)
		-DSDL_SSE2=$(usex cpu_flags_x86_sse2)
		-DSDL_SSE3=$(usex cpu_flags_x86_sse3)
		-DSDL_OSS=$(usex oss)
		-DSDL_ALSA=$(usex alsa)
		-DSDL_ALSA_SHARED=OFF
		-DSDL_JACK=$(usex jack)
		-DSDL_JACK_SHARED=OFF
		-DSDL_ESD=OFF
		-DSDL_PIPEWIRE=$(usex pipewire)
		-DSDL_PIPEWIRE_SHARED=OFF
		-DSDL_PULSEAUDIO=$(usex pulseaudio)
		-DSDL_PULSEAUDIO_SHARED=OFF
		-DSDL_ARTS=OFF
		-DSDL_LIBSAMPLERATE=$(usex libsamplerate)
		-DSDL_LIBSAMPLERATE_SHARED=OFF
		-DSDL_WERROR=OFF
		-DSDL_NAS=$(usex nas)
		-DSDL_NAS_SHARED=OFF
		-DSDL_SNDIO=$(usex sndio)
		-DSDL_SNDIO_SHARED=OFF
		-DSDL_DISKAUDIO=$(usex sound)
		-DSDL_DUMMYAUDIO=$(usex sound)
		-DSDL_WAYLAND=$(usex wayland)
		-DSDL_WAYLAND_SHARED=OFF
		-DSDL_WAYLAND_LIBDECOR=$(usex wayland)
		-DSDL_WAYLAND_LIBDECOR_SHARED=OFF
		-DSDL_RPI=OFF
		-DSDL_X11=$(usex X)
		-DSDL_X11_SHARED=OFF
		-DSDL_X11_XSCRNSAVER=$(usex xscreensaver)
		-DSDL_COCOA=$(usex aqua)
		-DSDL_DIRECTFB=OFF
		-DSDL_FUSIONSOUND=OFF
		-DSDL_KMSDRM=$(usex kms)
		-DSDL_KMSDRM_SHARED=OFF
		-DSDL_DUMMYVIDEO=$(usex video)
		-DSDL_OPENGL=$(usex opengl)
		-DSDL_OPENGLES=$(use gles1 || use gles2 && echo ON || echo OFF)
		-DSDL_VULKAN=$(usex vulkan)
		-DSDL_LIBUDEV=$(usex udev)
		-DSDL_DBUS=$(usex dbus)
		-DSDL_IBUS=$(usex ibus)
		-DSDL_CCACHE=OFF
		-DSDL_DIRECTX=OFF
		-DSDL_RPATH=OFF
		-DSDL_VIDEO_RENDER_D3D=OFF
		-DSDL_TESTS=$(usex test)
	)
	cmake-multilib_src_configure
}

src_compile() {
	multilib-minimal_src_compile

	if use doc; then
		cd docs || die
		doxygen || die
	fi
}

src_test() {
	unset SDL_GAMECONTROLLERCONFIG SDL_GAMECONTROLLER_USE_BUTTON_LABELS
	cmake-multilib_src_test
}

multilib_src_install_all() {
	rm -r "${ED}"/usr/share/licenses/ || die
	dodoc {BUGS,CREDITS,README-SDL,TODO,WhatsNew}.txt README.md docs/README*.md
	use doc && dodoc -r docs/output/html/
}
