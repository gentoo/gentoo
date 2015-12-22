# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE='threads(+)'

WAF_PV='1.8.12'

inherit eutils fdo-mime gnome2-utils pax-utils python-any-r1 waf-utils

DESCRIPTION="Media player based on MPlayer and mplayer2"
HOMEPAGE="https://mpv.io/"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/mpv-player/mpv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux"
	DOCS=( RELEASE_NOTES )
else
	EGIT_REPO_URI="https://github.com/mpv-player/mpv.git"
	inherit git-r3
fi
SRC_URI+=" https://waf.io/waf-${WAF_PV}"
DOCS+=( README.md etc/example.conf etc/input.conf )

# See Copyright in source tarball and bug #506946. Waf is BSD, libmpv is ISC.
LICENSE="GPL-2+ BSD ISC"
SLOT="0"
IUSE="+alsa archive bluray cdda +cli doc drm dvb +dvd egl +enca encode +iconv
jack jpeg lcms +libass libav libcaca libguess libmpv lua luajit openal
+opengl oss pulseaudio pvr raspberry-pi rubberband samba sdl selinux v4l vaapi
vdpau vf-dlopen wayland +X xinerama +xscreensaver xv"

REQUIRED_USE="
	|| ( cli libmpv )
	egl? ( opengl X )
	enca? ( iconv )
	lcms? ( opengl )
	libguess? ( iconv )
	luajit? ( lua )
	opengl? ( || ( wayland X ) )
	pvr? ( v4l )
	vaapi? ( X )
	vdpau? ( X )
	wayland? ( opengl )
	xinerama? ( X )
	xscreensaver? ( X )
	xv? ( X )
"

COMMON_DEPEND="
	!libav? ( >=media-video/ffmpeg-2.4.0:0=[encode?,threads,vaapi?,vdpau?] )
	libav? ( >=media-video/libav-11:0=[encode?,threads,vaapi?,vdpau?] )
	sys-libs/zlib
	alsa? ( >=media-libs/alsa-lib-1.0.18 )
	archive? ( >=app-arch/libarchive-3.0.0:= )
	bluray? ( >=media-libs/libbluray-0.3.0 )
	cdda? ( dev-libs/libcdio-paranoia )
	drm? ( x11-libs/libdrm )
	dvb? ( virtual/linuxtv-dvb-headers )
	dvd? (
		>=media-libs/libdvdnav-4.2.0
		>=media-libs/libdvdread-4.1.3
	)
	egl? ( media-libs/mesa[egl,wayland(-)?] )
	enca? ( app-i18n/enca )
	iconv? ( virtual/libiconv )
	jack? ( media-sound/jack-audio-connection-kit )
	jpeg? ( virtual/jpeg:0 )
	libass? (
		>=media-libs/libass-0.12.1:=[enca(-)?,fontconfig]
		virtual/ttf-fonts
	)
	libcaca? ( >=media-libs/libcaca-0.99_beta18 )
	libguess? ( >=app-i18n/libguess-1.0 )
	lua? (
		!luajit? ( || ( =dev-lang/lua-5.1*:= =dev-lang/lua-5.2*:= ) )
		luajit? ( dev-lang/luajit:2 )
	)
	openal? ( >=media-libs/openal-1.13 )
	pulseaudio? ( media-sound/pulseaudio )
	rubberband? ( >=media-libs/rubberband-1.8.0 )
	samba? ( net-fs/samba )
	sdl? ( media-libs/libsdl2[threads] )
	v4l? ( media-libs/libv4l )
	wayland? (
		>=dev-libs/wayland-1.6.0
		>=x11-libs/libxkbcommon-0.3.0
	)
	X? (
		x11-libs/libX11
		x11-libs/libXext
		>=x11-libs/libXrandr-1.2.0
		opengl? (
			x11-libs/libXdamage
			virtual/opengl
		)
		lcms? ( >=media-libs/lcms-2.6:2 )
		vaapi? ( >=x11-libs/libva-1.2.0[X] )
		vdpau? ( >=x11-libs/libvdpau-0.2 )
		xinerama? ( x11-libs/libXinerama )
		xscreensaver? ( x11-libs/libXScrnSaver )
		xv? ( x11-libs/libXv )
	)
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.8
	dev-python/docutils
	virtual/pkgconfig
	doc? ( dev-python/rst2pdf )
"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-mplayer )
"

pkg_pretend() {
	if ! use libass; then
		ewarn "You have disabled the libass support."
		ewarn "OSD and subtitles won't be available."
	fi

	if use openal; then
		ewarn "You have enabled the openal audio output. Be warned that"
		ewarn "this output is considered experimental by upstream."
	fi

	if use sdl; then
		ewarn "You have enabled the sdl video and audio outputs. Note that"
		ewarn "upstream provides these outputs for compatibility reasons only."
		ewarn "You probably don't need them under the normal circumstances."
	fi

	if use libav; then
		elog "You have enabled media-video/libav instead of media-video/ffmpeg."
		elog "Upstream recommends media-video/ffmpeg, as some functionality"
		elog "is not provided by media-video/libav."
	fi

	einfo "mpv optionally supports many different audio and video formats."
	einfo "You will need to enable support for the desired formats in your"
	einfo "libavcodec/libavformat provider:"
	einfo "    media-video/ffmpeg or media-video/libav"
}

src_prepare() {
	cp "${DISTDIR}/waf-${WAF_PV}" "${S}"/waf || die
	chmod 0755 "${S}"/waf || die
	epatch_user
}

src_configure() {
	local mywafargs=(
		--confdir="${EPREFIX}"/etc/${PN}
		--docdir="${EPREFIX}"/usr/share/doc/${PF}

		$(usex cli '' '--disable-cplayer')
		$(use_enable libmpv libmpv-shared)

		--disable-libmpv-static
		--disable-build-date	# keep build reproducible
		--disable-optimize	# do not add '-O2' to CFLAGS
		--disable-debug-build	# do not add '-g' to CFLAGS
		--disable-test		# avoid dev-util/cmocka automagic

		$(use_enable doc pdf-build)
		$(use_enable vf-dlopen vf-dlopen-filters)
		$(use_enable cli zsh-comp)

		# optional features
		$(use_enable iconv)
		$(use_enable libguess)
		$(use_enable samba libsmbclient)
		$(use_enable lua)
		$(use_enable libass)
		$(use_enable libass libass-osd)
		$(use_enable encode encoding)
		$(use_enable bluray libbluray)
		$(use_enable dvd dvdread)
		$(use_enable dvd dvdnav)
		$(use_enable cdda)
		$(use_enable enca)
		$(use_enable rubberband)
		$(use_enable lcms lcms2)
		--disable-vapoursynth	# vapoursynth is not packaged
		--disable-vapoursynth-lazy
		$(use_enable archive libarchive)

		--enable-libavfilter
		--enable-libavdevice
		$(usex luajit '--lua=luajit' '')

		# audio outputs
		$(use_enable sdl sdl2)	# SDL output is fallback for platforms where nothing better is available
		--disable-sdl1
		$(use_enable oss oss-audio)
		--disable-rsound	# media-sound/rsound is in pro-audio overlay only
		$(use_enable pulseaudio pulse)
		$(use_enable jack)
		$(use_enable openal)
		$(use_enable alsa)

		# video outputs
		$(use_enable wayland)
		$(use_enable X x11)
		$(use_enable xscreensaver xss)
		$(use_enable X xext)
		$(use_enable xv)
		$(use_enable xinerama)
		$(use_enable X xrandr)
		$(usex X "$(use_enable opengl gl-x11)" '--disable-gl-x11')
		$(use_enable egl egl-x11)
		$(usex wayland "$(use_enable opengl gl-wayland)" '--disable-gl-wayland')
		$(use_enable opengl gl)
		$(use_enable vdpau)
		$(usex vdpau "$(use_enable opengl vdpau-gl-x11)" '--disable-vdpau-gl-x11')
		$(use_enable vaapi)
		$(usex vaapi "$(use_enable opengl vaapi-glx)" '--disable-vaapi-glx')
		$(use_enable libcaca caca)
		$(use_enable drm)
		$(use_enable jpeg)
		$(use_enable raspberry-pi rpi)

		# hwaccels
		$(use_enable vaapi vaapi-hwaccel)

		# tv features
		$(use_enable v4l tv)
		$(use_enable v4l tv-v4l2)
		$(use_enable v4l libv4l2)
		$(use_enable pvr)
		$(use_enable dvb dvbin)
	)
	waf-utils_src_configure "${mywafargs[@]}"
}

src_install() {
	waf-utils_src_install

	if use cli && use luajit; then
		pax-mark -m "${ED}"usr/bin/mpv
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
