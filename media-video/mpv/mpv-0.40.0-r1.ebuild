# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )
PYTHON_COMPAT=( python3_{10..13} )
inherit flag-o-matic lua-single meson optfeature pax-utils python-single-r1 xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mpv-player/mpv.git"
else
	SRC_URI="https://github.com/mpv-player/mpv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux"
fi

DESCRIPTION="Media player for the command line"
HOMEPAGE="https://mpv.io/"

LICENSE="LGPL-2.1+ GPL-2+ BSD ISC MIT" #506946
SLOT="0/2" # soname
IUSE="
	+X +alsa aqua archive bluray cdda +cli coreaudio debug +drm dvb
	dvd +egl gamepad +iconv jack javascript jpeg lcms libcaca +libmpv
	+lua nvenc openal pipewire pulseaudio rubberband sdl selinux sixel
	sndio soc test tools +uchardet vaapi vdpau +vulkan wayland xv zimg
	zlib
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( cli libmpv )
	egl? ( || ( X drm wayland ) )
	lua? ( ${LUA_REQUIRED_USE} )
	nvenc? ( || ( egl vulkan ) )
	test? ( cli )
	tools? ( cli )
	uchardet? ( iconv )
	vaapi? ( || ( X drm wayland ) )
	vdpau? ( X )
	vulkan? ( || ( X wayland ) )
	xv? ( X )
"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	media-libs/libass:=[fontconfig]
	>=media-libs/libplacebo-7.349.0:=[vulkan?]
	>=media-video/ffmpeg-6.1:=[encode(+),soc(-)?,threads(+),vaapi?,vdpau?]
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
		media-libs/libdisplay-info:=
		x11-libs/libdrm
		egl? ( media-libs/mesa[gbm(+)] )
	)
	dvd? ( media-libs/libdvdnav )
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
	pipewire? ( media-video/pipewire:= )
	pulseaudio? ( media-libs/libpulse )
	rubberband? ( media-libs/rubberband:= )
	sdl? ( media-libs/libsdl2[sound,threads(+),video] )
	sixel? ( media-libs/libsixel )
	sndio? ( media-sound/sndio:= )
	vaapi? ( media-libs/libva:=[X?,drm(+)?,wayland?] )
	vdpau? ( x11-libs/libvdpau )
	vulkan? ( media-libs/vulkan-loader[X?,wayland?] )
	wayland? (
		dev-libs/wayland
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
	vulkan? ( dev-util/vulkan-headers )
	wayland? ( >=dev-libs/wayland-protocols-1.41 )
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/meson-1.3.0
	virtual/pkgconfig
	cli? ( dev-python/docutils )
	wayland? ( dev-util/wayland-scanner )
"

pkg_pretend() {
	if has_version "${CATEGORY}/${PN}[X,opengl]" && use !egl; then #953107
		ewarn "${PN}'s 'opengl' USE was removed in favour of the 'egl' USE as it was"
		ewarn "only for the deprecated 'gl-x11' mpv option when 'egl-x11/wayland'"
		ewarn "should be used if --gpu-api=opengl. It is recommended to enable 'egl'"
		ewarn "unless using vulkan (default since ${PN}-0.40) or something else."
	fi
}

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
		$(meson_feature sdl sdl2-video)
		$(meson_feature sixel)
		$(meson_feature wayland)
		$(meson_feature xv)

		-Dgl=$(use aqua || use egl || use libmpv &&
			echo enabled || echo disabled)
		$(meson_feature egl)
		$(meson_feature libmpv plain-gl)

		$(meson_feature vulkan)

		# hardware decoding
		$(meson_feature nvenc cuda-hwaccel)
		$(meson_feature vaapi)
		$(meson_feature vdpau)
	)

	meson_src_configure
}

src_test() {
	# ffmpeg tests are picky and easily break without necessarily
	# meaning that there are runtime issues (bug #921091,#924276)
	meson_src_test --no-suite ffmpeg
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

	optfeature "various websites URL support$(usev !lua \
		" (requires ${PN} with USE=lua)")" net-misc/yt-dlp
}
