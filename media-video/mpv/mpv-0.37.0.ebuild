# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )
PYTHON_COMPAT=( python3_{10..12} )
inherit flag-o-matic lua-single meson optfeature pax-utils python-single-r1 xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mpv-player/mpv.git"
else
	SRC_URI="https://github.com/mpv-player/mpv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~loong ppc ppc64 ~riscv x86 ~amd64-linux"
fi

DESCRIPTION="Media player for the command line"
HOMEPAGE="https://mpv.io/"

LICENSE="LGPL-2.1+ GPL-2+ BSD ISC MIT" #506946
SLOT="0/2" # soname
IUSE="
	+X +alsa aqua archive bluray cdda +cli coreaudio debug +drm dvb
	dvd +egl gamepad +iconv jack javascript jpeg lcms libcaca +libmpv
	+lua mmal nvenc openal opengl pipewire pulseaudio raspberry-pi
	rubberband sdl selinux sixel sndio test tools +uchardet vaapi
	vdpau vulkan wayland xv zimg zlib
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( cli libmpv )
	egl? ( || ( X drm wayland ) )
	lua? ( ${LUA_REQUIRED_USE} )
	nvenc? ( || ( egl opengl vulkan ) )
	opengl? ( || ( X aqua ) )
	test? ( cli )
	tools? ( cli )
	uchardet? ( iconv )
	vaapi? ( || ( X drm wayland ) )
	vdpau? ( X )
	vulkan? ( || ( X wayland ) )
	xv? ( X )
"
RESTRICT="!test? ( test )"

# raspberry-pi: default to -bin given non-bin is known broken (bug #893422)
COMMON_DEPEND="
	media-libs/libass:=[fontconfig]
	>=media-libs/libplacebo-6.338:=[opengl?,vulkan?]
	>=media-video/ffmpeg-4.4:=[encode,threads,vaapi?,vdpau?]
	X? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
		x11-libs/libXext
		x11-libs/libXpresent
		x11-libs/libXrandr
		xv? ( x11-libs/libXv )
	)
	alsa? ( media-libs/alsa-lib )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray:= )
	cdda? (
		dev-libs/libcdio-paranoia:=
		dev-libs/libcdio:=
	)
	drm? (
		x11-libs/libdrm
		egl? ( media-libs/mesa[gbm(+)] )
	)
	dvd? (
		media-libs/libdvdnav
		media-libs/libdvdread:=
	)
	egl? (
		media-libs/libglvnd
		media-libs/libplacebo[opengl]
	)
	gamepad? ( media-libs/libsdl2[joystick] )
	iconv? (
		virtual/libiconv
		uchardet? ( app-i18n/uchardet )
	)
	jack? ( virtual/jack )
	javascript? ( dev-lang/mujs:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	lcms? ( media-libs/lcms:2 )
	libcaca? ( media-libs/libcaca )
	lua? ( ${LUA_DEPS} )
	openal? ( media-libs/openal )
	opengl? ( media-libs/libglvnd[X?] )
	pipewire? ( media-video/pipewire:= )
	pulseaudio? ( media-libs/libpulse )
	raspberry-pi? (
		|| (
			media-libs/raspberrypi-userland-bin
			media-libs/raspberrypi-userland
		)
	)
	rubberband? ( media-libs/rubberband )
	sdl? ( media-libs/libsdl2[sound,threads,video] )
	sixel? ( media-libs/libsixel )
	sndio? ( media-sound/sndio:= )
	vaapi? ( media-libs/libva:=[X?,drm(+)?,wayland?] )
	vdpau? ( x11-libs/libvdpau )
	vulkan? (
		media-libs/shaderc
		media-libs/vulkan-loader[X?,wayland?]
	)
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
		x11-libs/libxkbcommon
	)
	zimg? ( media-libs/zimg )
	zlib? ( sys-libs/zlib:= )
"
RDEPEND="
	${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-mplayer )
	tools? ( ${PYTHON_DEPS} )
"
DEPEND="
	${COMMON_DEPEND}
	X? ( x11-base/xorg-proto )
	dvb? ( sys-kernel/linux-headers )
	nvenc? ( media-libs/nv-codec-headers )
	wayland? ( dev-libs/wayland-protocols )
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	cli? ( dev-python/docutils )
	wayland? ( dev-util/wayland-scanner )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.37.0-drm-fix.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
	if use !debug; then
		if use test; then
			einfo "Skipping -DNDEBUG due to USE=test"
		else
			append-cppflags -DNDEBUG # treated specially
		fi
	fi

	mpv_feature_multi() {
		local use set
		for use in ${1} ${2}; do
			use ${use} || set=disabled
		done
		echo -D${3-${2}}=${set-enabled}
	}

	local emesonargs=(
		$(meson_use cli cplayer)
		$(meson_use libmpv)
		$(meson_use test tests)

		$(meson_feature cli html-build)
		$(meson_feature cli manpage-build)
		-Dpdf-build=disabled

		-Dbuild-date=false

		# misc options
		$(meson_feature archive libarchive)
		$(meson_feature bluray libbluray)
		$(meson_feature cdda)
		-Dcplugins=enabled
		$(meson_feature dvb dvbin)
		$(meson_feature dvd dvdnav)
		$(meson_feature gamepad sdl2-gamepad)
		$(meson_feature iconv)
		$(meson_feature javascript)
		-Dlibavdevice=enabled
		$(meson_feature lcms lcms2)
		-Dlua=$(usex lua "${ELUA}" disabled)
		$(meson_feature rubberband)
		-Dsdl2=$(use gamepad || use sdl && echo enabled || echo disabled) #857156
		$(meson_feature uchardet)
		-Dvapoursynth=disabled # only available in overlays
		$(meson_feature zimg)
		$(meson_feature zlib)

		# audio output
		$(meson_feature alsa)
		$(meson_feature coreaudio)
		$(meson_feature jack)
		$(meson_feature openal)
		$(meson_feature pipewire)
		$(meson_feature pulseaudio pulse)
		$(meson_feature sdl sdl2-audio)
		$(meson_feature sndio)

		# video output
		$(meson_feature X x11)
		$(meson_feature aqua cocoa)
		$(meson_feature drm)
		$(meson_feature jpeg)
		$(meson_feature libcaca caca)
		$(meson_feature mmal rpi-mmal)
		$(meson_feature sdl sdl2-video)
		$(meson_feature sixel)
		$(meson_feature wayland)
		$(meson_feature xv)

		-Dgl=$(use egl || use libmpv || use opengl || use raspberry-pi &&
			echo enabled || echo disabled)
		$(meson_feature egl)
		$(mpv_feature_multi egl X egl-x11)
		$(mpv_feature_multi egl drm gbm) # gbm is only used by egl-drm
		$(mpv_feature_multi egl drm egl-drm)
		$(mpv_feature_multi egl wayland egl-wayland)
		$(meson_feature libmpv plain-gl)
		$(mpv_feature_multi opengl X gl-x11)
		$(mpv_feature_multi opengl aqua gl-cocoa)
		$(meson_feature raspberry-pi rpi)

		$(meson_feature vulkan)
		$(meson_feature vulkan shaderc)

		# hardware decoding
		$(meson_feature nvenc cuda-hwaccel)
		$(meson_feature nvenc cuda-interop)

		$(meson_feature vaapi)
		$(mpv_feature_multi vaapi X vaapi-x11)
		$(mpv_feature_multi vaapi drm vaapi-drm)
		$(mpv_feature_multi vaapi wayland vaapi-wayland)

		$(meson_feature vdpau)
		$(mpv_feature_multi vdpau opengl vdpau-gl-x11)

		$(mpv_feature_multi aqua opengl videotoolbox-gl)

		# notable options left to automagic
		#dmabuf-wayland: USE="drm wayland" + plus memfd_create support
		#vulkan-interop: USE="vulkan" + >=ffmpeg-6.1
		# TODO?: perhaps few more similar compound options should be left auto
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	if use lua; then
		insinto /usr/share/${PN}
		doins -r TOOLS/lua

		if use cli && use lua_single_target_luajit; then
			pax-mark -m "${ED}"/usr/bin/${PN}
		fi
	fi

	if use tools; then
		dobin TOOLS/{mpv_identify.sh,umpv}
		newbin TOOLS/idet.sh mpv_idet.sh
		python_fix_shebang "${ED}"/usr/bin/umpv
	fi

	if use cli; then
		dodir /usr/share/doc/${PF}/html
		mv "${ED}"/usr/share/doc/{mpv,${PF}/html}/mpv.html || die
		mv "${ED}"/usr/share/doc/{mpv,${PF}/examples} || die
	fi

	local GLOBIGNORE=*/*build*:*/*policy*
	dodoc RELEASE_NOTES DOCS/*.{md,rst}
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "URL support with USE=lua" net-misc/yt-dlp
}
