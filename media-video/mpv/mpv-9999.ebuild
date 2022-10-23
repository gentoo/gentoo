# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..2} luajit )
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE='threads(+)'

inherit edo flag-o-matic lua-single optfeature meson pax-utils python-single-r1 toolchain-funcs xdg

DESCRIPTION="Media player based on MPlayer and mplayer2"
HOMEPAGE="https://mpv.io/ https://github.com/mpv-player/mpv"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/mpv-player/mpv.git"
	inherit git-r3

	DOCS=()
else
	SRC_URI="https://github.com/mpv-player/mpv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux"

	DOCS=( RELEASE_NOTES )
fi

DOCS+=( README.md DOCS/{client-api,interface}-changes.rst )

# See Copyright in sources and Gentoo bug #506946. libmpv is ISC.
# See https://github.com/mpv-player/mpv/blob/6265724f3331e3dee8d9ec2b6639def5004a5fa2/Copyright which
# says other files may be BSD/MIT/ISC.
LICENSE="LGPL-2.1+ GPL-2+ BSD MIT ISC"
SLOT="0"
IUSE="+alsa aqua archive bluray cdda +cli coreaudio cplugins debug doc drm dvb
	dvd +egl gamepad gbm +iconv jack javascript jpeg lcms libcaca libmpv +lua
	mmal nvenc openal +opengl pipewire pulseaudio raspberry-pi rubberband sdl
	selinux sndio test tools +uchardet vaapi vdpau +vector vulkan wayland +X +xv zlib zimg"

REQUIRED_USE="
	|| ( cli libmpv )
	aqua? ( opengl )
	egl? ( || ( gbm X wayland ) )
	gamepad? ( sdl )
	gbm? ( drm egl opengl )
	lcms? ( opengl )
	lua? ( ${LUA_REQUIRED_USE} )
	nvenc? ( opengl )
	opengl? ( || ( aqua egl X raspberry-pi !cli ) )
	raspberry-pi? ( opengl )
	test? ( opengl )
	tools? ( cli )
	uchardet? ( iconv )
	vaapi? ( || ( gbm X wayland ) )
	vdpau? ( X )
	vulkan? ( || ( X wayland ) )
	wayland? ( egl )
	X? ( egl? ( opengl ) )
	xv? ( X )
	${PYTHON_REQUIRED_USE}
"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=media-video/ffmpeg-4.0:0=[encode,threads,vaapi?,vdpau?]
	alsa? ( >=media-libs/alsa-lib-1.0.18 )
	archive? ( >=app-arch/libarchive-3.4.0:= )
	bluray? ( >=media-libs/libbluray-0.3.0:= )
	cdda? ( dev-libs/libcdio-paranoia
			dev-libs/libcdio:= )
	drm? ( x11-libs/libdrm )
	dvd? (
		>=media-libs/libdvdnav-4.2.0:=
		>=media-libs/libdvdread-4.1.0:=
	)
	egl? ( media-libs/mesa[egl(+),gbm(+)?,wayland(-)?] )
	gamepad? ( media-libs/libsdl2 )
	iconv? (
		virtual/libiconv
		uchardet? ( app-i18n/uchardet )
	)
	jack? ( virtual/jack )
	javascript? ( >=dev-lang/mujs-1.0.0 )
	jpeg? ( media-libs/libjpeg-turbo:= )
	lcms? ( >=media-libs/lcms-2.6:2 )
	>=media-libs/libass-0.12.1:=[fontconfig,harfbuzz(+)]
	virtual/ttf-fonts
	libcaca? ( >=media-libs/libcaca-0.99_beta18 )
	lua? ( ${LUA_DEPS} )
	openal? ( >=media-libs/openal-1.13 )
	pulseaudio? ( media-libs/libpulse )
	pipewire? ( media-video/pipewire:= )
	raspberry-pi? ( >=media-libs/raspberrypi-userland-0_pre20160305-r1 )
	rubberband? ( >=media-libs/rubberband-1.8.0 )
	sdl? ( media-libs/libsdl2[sound,threads,video] )
	sndio? ( media-sound/sndio )
	vaapi? ( media-libs/libva:=[drm(+)?,X?,wayland?] )
	vdpau? ( x11-libs/libvdpau )
	vulkan? (
		>=media-libs/libplacebo-4.192.1:=[vulkan]
		media-libs/shaderc
	)
	wayland? (
		>=dev-libs/wayland-1.6.0
		>=dev-libs/wayland-protocols-1.14
		>=x11-libs/libxkbcommon-0.3.0
	)
	X? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libXpresent
		x11-libs/libXrandr
		opengl? (
			x11-libs/libXdamage
			virtual/opengl
		)
		xv? ( x11-libs/libXv )
	)
	zlib? ( sys-libs/zlib )
	zimg? ( >=media-libs/zimg-2.9.2 )
"
DEPEND="${COMMON_DEPEND}
	dvb? ( virtual/linuxtv-dvb-headers )
	nvenc? ( >=media-libs/nv-codec-headers-8.2.15.7 )
"
RDEPEND="${COMMON_DEPEND}
	nvenc? ( x11-drivers/nvidia-drivers[X] )
	selinux? ( sec-policy/selinux-mplayer )
	tools? ( ${PYTHON_DEPS} )
"
BDEPEND="dev-python/docutils
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-9999-docdir.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup
	use tools && python-single-r1_pkg_setup
}

src_configure() {
	tc-export CC PKG_CONFIG AR

	if use raspberry-pi; then
		append-cflags -I"${ESYSROOT}/opt/vc/include"
		append-ldflags -L"${ESYSROOT}/opt/vc/lib"
	fi

	if use debug && ! use test; then
		append-cppflags -DNDEBUG
	fi

	local emesonargs=(
		-Dbuild-date=false
		$(meson_use cli cplayer)
		$(meson_use libmpv)
		$(meson_use test tests)

		$(meson_feature doc html-build)
		-Dmanpage-build=enabled
		-Dpdf-build=disabled

		$(meson_feature cplugins)
		$(meson_feature iconv)
		$(meson_feature javascript)
		$(meson_feature zlib)
		$(meson_feature bluray libbluray)
		$(meson_feature dvd dvdnav)

		$(meson_feature cdda)

		$(meson_feature uchardet)
		$(meson_feature rubberband)
		$(meson_feature lcms lcms2)

		# Only available in overlays.
		-Dvapoursynth=disabled

		$(meson_feature vector)

		$(meson_feature archive libarchive)

		-Dlibavdevice=enabled

		# Needed for either of the more specific audio or video options
		# bug #857156
		$(meson_feature sdl sdl2)

		# Audio outputs:
		$(meson_feature sdl sdl2-audio)
		$(meson_feature pulseaudio pulse)
		$(meson_feature jack)
		$(meson_feature openal)
		$(meson_feature pipewire)
		-Dopensles=disabled
		$(meson_feature alsa)
		$(meson_feature coreaudio)
		$(meson_feature sndio)

		# Video outputs:
		$(meson_feature sdl sdl2-video)
		$(meson_feature aqua cocoa)
		$(meson_feature drm)
		$(meson_feature gbm)
		$(meson_feature wayland)
		$(meson_feature X x11)
		$(meson_feature xv)

		$(meson_feature opengl gl)
		$(usex opengl "$(meson_feature aqua gl-cocoa)" '-Dgl-cocoa=disabled')
		$(usex opengl "$(meson_feature X gl-x11)" '-Dgl-x11=disabled')

		$(meson_feature egl)
		$(usex egl "$(meson_feature X egl-x11)" "-Degl-x11=disabled")
		$(usex egl "$(meson_feature gbm egl-drm)" "-Degl-drm=disabled")
		$(usex opengl "$(meson_feature wayland egl-wayland)" '-Degl-wayland=disabled')

		$(meson_feature vdpau)
		$(usex vdpau "$(meson_feature opengl vdpau-gl-x11)" '-Dvdpau-gl-x11=disabled')

		$(meson_feature vaapi) # See below for vaapi-glx, vaapi-x-egl.
		$(usex vaapi "$(meson_feature X vaapi-x11)" "-Dvaapi-x11=disabled")
		$(usex vaapi "$(meson_feature wayland vaapi-wayland)" "-Dvaapi-wayland=disabled")
		$(usex vaapi "$(meson_feature gbm vaapi-drm)" "-Dvaapi-drm=disabled")

		$(meson_feature libcaca caca)
		$(meson_feature jpeg)
		$(meson_feature vulkan shaderc)
		$(meson_feature vulkan libplacebo)
		$(meson_feature raspberry-pi rpi)
		$(meson_feature mmal rpi-mmal)

		-Dsixel=disabled
		-Dspirv-cross=disabled

		$(usex libmpv "$(meson_feature opengl plain-gl)" "-Dplain-gl=disabled")
		$(meson_feature opengl gl)
		$(meson_feature vulkan)
		$(meson_feature gamepad sdl2-gamepad)

		# HWaccels:
		# Automagic Video Toolbox HW acceleration. See Gentoo bug 577332.
		$(meson_feature nvenc cuda-hwaccel)
		$(meson_feature nvenc cuda-interop)

		# TV features:
		$(meson_feature dvb dvbin)

		# Miscellaneous features:
		$(meson_feature zimg)
	)

	if use lua; then
		emesonargs+=( -Dlua="${ELUA}" )
	else
		emesonargs+=( -Dlua=disabled )
	fi

	if use vaapi && use X; then
		emesonargs+=(
			$(meson_feature egl vaapi-x-egl)
		)
	fi

	# Not for us
	emesonargs+=(
		-Duwp=disabled
		-Daudiounit=disabled
		-Doss-audio=disabled
		-Dwasapi=disabled

		-Dd3d11=disabled
		-Ddirect3d=disabled
	)

	meson_src_configure
}

src_test() {
	edo "${BUILD_DIR}"/mpv --no-config -v --unittest=all-simple
}

src_install() {
	meson_src_install

	if use lua; then
		insinto /usr/share/${PN}
		doins -r TOOLS/lua
	fi

	if use cli && use lua_single_target_luajit; then
		pax-mark -m "${ED}"/usr/bin/${PN}
	fi

	if use tools; then
		dobin TOOLS/{mpv_identify.sh,umpv}
		newbin TOOLS/idet.sh mpv_idet.sh
		python_fix_shebang "${ED}"/usr/bin/umpv
	fi
}

pkg_postinst() {
	local rv softvol_0_18_1=0 osc_0_21_0=0 txtsubs_0_24_0=0 opengl_0_25_0=0

	for rv in ${REPLACING_VERSIONS}; do
		ver_test ${rv} -lt 0.18.1 && softvol_0_18_1=1
		ver_test ${rv} -lt 0.21.0 && osc_0_21_0=1
		ver_test ${rv} -lt 0.24.0 && txtsubs_0_24_0=1
		ver_test ${rv} -lt 0.25.0 && ! use opengl && opengl_0_25_0=1
	done

	if [[ ${softvol_0_18_1} -eq 1 ]]; then
		elog "Since version 0.18.1 the software volume control is always enabled."
		elog "This means that volume controls don't change the system volume,"
		elog "e.g. per-application volume with PulseAudio."
		elog "If you want to restore the previous behaviour, please refer to"
		elog
		elog "https://wiki.gentoo.org/wiki/Mpv#Volume_in_0.18.1"
		elog
	fi

	if [[ ${osc_0_21_0} -eq 1 ]]; then
		elog "In version 0.21.0 the default OSC layout was changed."
		elog "If you want to restore the previous layout, please refer to"
		elog
		elog "https://wiki.gentoo.org/wiki/Mpv#OSC_in_0.21.0"
		elog
	fi

	if [[ ${txtsubs_0_24_0} -eq 1 ]]; then
		elog "Since version 0.24.0 subtitles with .txt extension aren't autoloaded."
		elog "If you want to restore the previous behaviour, please refer to"
		elog
		elog "https://wiki.gentoo.org/wiki/Mpv#Subtitles_with_.txt_extension_in_0.24.0"
		elog
	fi

	if [[ ${opengl_0_25_0} -eq 1 ]]; then
		elog "Since version 0.25.0 the 'opengl' USE flag is mapped to"
		elog "the 'opengl' video output and no longer explicitly requires"
		elog "X11 or Mac OS Aqua. Consider enabling the 'opengl' USE flag."
	fi

	optfeature "URL support" net-misc/yt-dlp

	xdg_icon_cache_update
	xdg_desktop_database_update
}
