# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal

MY_P="SDL2-${PV}"
DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://www.libsdl.org/"
SRC_URI="https://www.libsdl.org/release/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc x86"

IUSE="alsa aqua cpu_flags_ppc_altivec cpu_flags_x86_3dnow cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 custom-cflags dbus doc fcitx4 gles1 gles2 +haptic ibus jack +joystick kms libsamplerate nas opengl oss pipewire pulseaudio sndio +sound static-libs test +threads udev +video video_cards_vc4 vulkan wayland X xscreensaver"
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
	vulkan? ( video )
	wayland? ( gles2 )
	xscreensaver? ( X )
"

COMMON_DEPEND="
	virtual/libiconv[${MULTILIB_USEDEP}]
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	fcitx4? ( app-i18n/fcitx:4 )
	gles1? ( media-libs/mesa[${MULTILIB_USEDEP},gles1(+)] )
	gles2? ( >=media-libs/mesa-9.1.6[${MULTILIB_USEDEP},gles2(+)] )
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
	vulkan? ( media-libs/vulkan-loader )
"
DEPEND="
	${COMMON_DEPEND}
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

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.16-static-libs.patch
)

src_prepare() {
	default

	# Unbundle some headers.
	rm -r src/video/khronos || die
	ln -s "${ESYSROOT}/usr/include" src/video/khronos || die
	if ! use vulkan
	then
		sed -i '/testvulkan$(EXE) \\/d' "test/Makefile.in" || die
	fi

	# SDL seems to customize SDL_config.h.in to remove macros like
	# PACKAGE_NAME. Add AT_NOEAUTOHEADER="yes" to prevent those macros from
	# being reintroduced.
	# https://bugs.gentoo.org/764959
	AT_NOEAUTOHEADER="yes" AT_M4DIR="${BROOT}/usr/share/aclocal acinclude" \
		eautoreconf
}

multilib_src_configure() {
	use custom-cflags || strip-flags

	if use ibus; then
		local -x IBUS_CFLAGS="-I${ESYSROOT}/usr/include/ibus-1.0 -I${ESYSROOT}/usr/include/glib-2.0 -I${ESYSROOT}/usr/$(get_libdir)/glib-2.0/include"
	fi

	# sorted by `./configure --help`
	local myeconfargs=(
		$(use_enable static-libs static)
		--enable-system-iconv
		--enable-atomic
		$(use_enable sound audio)
		$(use_enable video)
		--enable-render
		--enable-events
		$(use_enable joystick)
		$(use_enable haptic)
		--enable-power
		--enable-filesystem
		$(use_enable threads pthreads)
		--enable-timers
		--enable-file
		--enable-loadso
		--enable-cpuinfo
		--enable-assembly
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_x86_sse ssemath)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable cpu_flags_x86_3dnow 3dnow)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable oss)
		$(use_enable alsa)
		--disable-alsa-shared
		$(use_enable jack)
		--disable-jack-shared
		--disable-esd
		$(use_enable pipewire)
		--disable-pipewire-shared
		$(use_enable pulseaudio)
		--disable-pulseaudio-shared
		--disable-arts
		$(use_enable libsamplerate)
		--disable-libsamplerate-shared
		--disable-werror
		$(use_enable nas)
		--disable-nas-shared
		$(use_enable sndio)
		--disable-sndio-shared
		$(use_enable sound diskaudio)
		$(use_enable sound dummyaudio)
		$(use_enable wayland video-wayland)
		--disable-wayland-shared
		$(use_enable wayland libdecor)
		--disable-libdecor-shared
		$(use_enable video_cards_vc4 video-rpi)
		$(use_enable X video-x11)
		--disable-x11-shared
		$(use_enable X video-x11-xcursor)
		$(use_enable X video-x11-xdbe)
		$(use_enable X video-x11-xfixes)
		$(use_enable X video-x11-xinput)
		$(use_enable X video-x11-xrandr)
		$(use_enable xscreensaver video-x11-scrnsaver)
		$(use_enable X video-x11-xshape)
		$(use_enable aqua video-cocoa)
		--disable-video-directfb
		--disable-fusionsound
		--disable-fusionsound-shared
		$(use_enable kms video-kmsdrm)
		--disable-kmsdrm-shared
		$(use_enable video video-dummy)
		$(use_enable opengl video-opengl)
		$(use_enable gles1 video-opengles1)
		$(use_enable gles2 video-opengles2)
		$(use_enable vulkan video-vulkan)
		$(use_enable udev libudev)
		$(use_enable dbus)
		$(use_enable fcitx4 fcitx)
		$(use_enable ibus)
		--disable-directx
		--disable-rpath
		--disable-render-d3d
		$(use_with X x)
		ac_cv_header_libunwind_h=no
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	if use test; then
		# Most of these workarounds courtesy Debian
		# https://salsa.debian.org/sdl-team/libsdl2/-/blob/debian/latest/debian/rules
		local mytestargs=(
			--x-includes="/usr/include"
			--x-libraries="/usr/$(get_libdir)"
			SDL_CFLAGS="-I${S}/include"
			SDL_LIBS="-L${BUILD_DIR}/build/.libs -lSDL2"
			ac_cv_lib_SDL2_ttf_TTF_Init=no
			CFLAGS="${CPPFLAGS} ${CFLAGS} ${LDFLAGS}"
		)

		mkdir "${BUILD_DIR}/test" || die
		cd "${BUILD_DIR}/test" || die
		ECONF_SOURCE="${S}/test" econf "${mytestargs[@]}"
	fi
}

multilib_src_compile() {
	emake all V=1
	use test && emake -C test all V=1
}

src_compile() {
	multilib-minimal_src_compile

	if use doc; then
		cd docs || die
		doxygen || die
	fi
}

multilib_src_test() {
	LD_LIBRARY_PATH="${BUILD_DIR}/build/.libs" emake -C test check V=1
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	# Do not delete the static .a libraries here as some are
	# mandatory. They may be needed even when linking dynamically.
	find "${ED}" -type f -name "*.la" -delete || die

	dodoc {BUGS,CREDITS,README-SDL,TODO,WhatsNew}.txt README.md docs/README*.md
	use doc && dodoc -r docs/output/html/
}
