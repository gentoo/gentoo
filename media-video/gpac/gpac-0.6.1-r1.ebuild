# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/gpac/gpac"
	KEYWORDS=""
else
	SRC_URI="https://github.com/gpac/gpac/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi

inherit eutils flag-o-matic multilib toolchain-funcs ${SCM}

DESCRIPTION="GPAC is an implementation of the MPEG-4 Systems standard developed from scratch in ANSI C"
HOMEPAGE="http://gpac.wp.mines-telecom.fr/"

LICENSE="GPL-2"
SLOT="0"
IUSE="a52 aac alsa debug dvb ffmpeg ipv6 jack jpeg jpeg2k mad opengl oss png
	pulseaudio sdl ssl static-libs theora truetype vorbis xml xvid X"

RDEPEND="
	a52? ( media-libs/a52dec )
	aac? ( >=media-libs/faad2-2.0 )
	alsa? ( media-libs/alsa-lib )
	dvb? ( media-tv/linuxtv-dvb-apps )
	ffmpeg? ( virtual/ffmpeg )
	jack? ( media-sound/jack-audio-connection-kit )
	jpeg? ( virtual/jpeg )
	mad? ( >=media-libs/libmad-0.15.1b )
	opengl? ( virtual/opengl media-libs/freeglut virtual/glu )
	>=media-libs/libogg-1.1
	png? ( >=media-libs/libpng-1.4 )
	vorbis? ( >=media-libs/libvorbis-1.1 )
	theora? ( media-libs/libtheora )
	truetype? ( >=media-libs/freetype-2.1.4 )
	xml? ( >=dev-libs/libxml2-2.6.0 )
	xvid? ( >=media-libs/xvid-1.0.1 )
	sdl? ( media-libs/libsdl )
	jpeg2k? ( media-libs/openjpeg:0 )
	ssl? ( dev-libs/openssl )
	pulseaudio? ( media-sound/pulseaudio )
	X? (
		x11-libs/libXt
		x11-libs/libX11
		x11-libs/libXv
		x11-libs/libXext
	)"
# disabled upstream, see applications/Makefile
# wxwidgets? ( =x11-libs/wxGTK-2.8* )

DEPEND="${RDEPEND}"

my_use() {
	local flag="$1" pflag="${2:-$1}"
	if use ${flag}; then
		echo "--use-${pflag}=system"
	else
		echo "--use-${pflag}=no"
	fi
}

src_prepare() {
	epatch	"${FILESDIR}"/110_all_implicitdecls.patch \
			"${FILESDIR}"/${PN}-0.5.3-static-libs.patch \
			"${FILESDIR}"/${PN}-0.5.2-gf_isom_set_pixel_aspect_ratio.patch
	sed -i -e "s:\(--disable-.*\)=\*):\1):" configure || die
}

src_configure() {
	tc-export CC CXX AR RANLIB

	econf \
		--enable-svg \
		--enable-pic \
		--disable-amr \
		--use-js=no \
		--use-ogg=system \
		$(use_enable alsa) \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable jack jack yes) \
		$(use_enable opengl 3d) \
		$(use_enable oss oss-audio) \
		$(use_enable pulseaudio pulseaudio yes) \
		$(use_enable sdl) \
		$(use_enable ssl) \
		$(use_enable static-libs static-lib) \
		$(use_enable X x11) $(use_enable X x11-shm) $(use_enable X x11-xv) \
		--disable-wx \
		$(my_use a52) \
		$(my_use aac faad) \
		$(my_use dvb dvbx) \
		$(my_use ffmpeg) \
		$(my_use jpeg) \
		$(my_use jpeg2k openjpeg) \
		$(my_use mad) \
		$(my_use png) \
		$(my_use theora) \
		$(my_use truetype ft) \
		$(my_use vorbis) \
		$(my_use xvid) \
		--extra-cflags="${CFLAGS}" \
		--cc="$(tc-getCC)" \
		--libdir="/$(get_libdir)" \
		--verbose
}

src_install() {
	emake STRIP="true" DESTDIR="${D}" install
	emake STRIP="true" DESTDIR="${D}" install-lib
	dodoc AUTHORS BUGS Changelog README.md TODO
	dodoc doc/*.txt
	dohtml doc/*.html
}
