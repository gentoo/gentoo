# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MIN_VERSION="2.8.8"

inherit cmake-utils

LICENSE="MIT"
HOMEPAGE="https://github.com/i-rinat/freshplayerplugin"
DESCRIPTION="PPAPI-host NPAPI-plugin adapter for flashplayer in npapi based browsers"
SRC_URI="https://github.com/i-rinat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT=0
IUSE="gles2 gtk3 jack libav libressl pulseaudio v4l vaapi vdpau"

KEYWORDS="~amd64"

HWDEC_DEPEND="
	libav? ( media-video/libav:0=[vaapi?,vdpau?] )
	!libav? ( media-video/ffmpeg:0=[vaapi?,vdpau?] )
	x11-libs/libva
	x11-libs/libvdpau
"

COMMON_DEPEND="
	dev-libs/glib:2=
	dev-libs/icu:0=
	dev-libs/libevent:=[threads]
	media-libs/alsa-lib:=
	media-libs/freetype:2=
	media-libs/mesa:=[egl,gles2?]
	x11-libs/cairo:=[X]
	x11-libs/libXcursor:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libdrm:=
	x11-libs/pango:=[X]
	jack? (
		media-sound/jack-audio-connection-kit
		media-libs/soxr
	)
	pulseaudio? ( media-sound/pulseaudio )
	!gtk3? ( x11-libs/gtk+:2= )
	gtk3? ( x11-libs/gtk+:3= )
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
	v4l? ( media-libs/libv4l:0= )
	vaapi? ( ${HWDEC_DEPEND} )
	vdpau? ( ${HWDEC_DEPEND} )
"

DEPEND="${COMMON_DEPEND}
	dev-util/ragel
	virtual/pkgconfig
	"
RDEPEND="${COMMON_DEPEND}
	www-plugins/adobe-flash:22[abi_x86_64,ppapi(+)]
	"

PATCHES=( "${FILESDIR}/0.3.5-cmake.patch" "${FILESDIR}/0.3.4-git-revision.patch" )
DOCS=( ChangeLog data/freshwrapper.conf.example README.md )

src_configure() {
	mycmakeargs=(
		-DWITH_JACK=$(usex jack)
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_GTK=$(usex gtk3 3 2)
		-DWITH_GLES2=$(usex gles2)
		-DWITH_LIBV4L2=$(usex v4l)
		-DCMAKE_SKIP_RPATH=1
	)
	if use vaapi || use vdpau ; then
		mycmakeargs+=( -DWITH_HWDEC=1 )
	else
		mycmakeargs+=( -DWITH_HWDEC=0 )
	fi
	cmake-utils_src_configure
}
