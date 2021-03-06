# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal

MY_COMMIT="99d7f1d1c5492f0fb3c799255042ca7a3f4a5de4"
DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://libsdl.org/"
SRC_URI="https://github.com/libsdl-org/SDL-1.2/archive/${MY_COMMIT}.tar.gz -> SDL-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
# WARNING:
# If you turn on the custom-cflags use flag in USE and something breaks,
# you pick up the pieces.  Be prepared for bug reports to be marked INVALID.
IUSE="aalib alsa custom-cflags dga fbcon +joystick libcaca nas opengl oss pulseaudio +sound static-libs tslib +video X xinerama xv"

RDEPEND="
	aalib? ( >=media-libs/aalib-1.4_rc5-r6[${MULTILIB_USEDEP}] )
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	libcaca? ( >=media-libs/libcaca-0.99_beta18-r1[${MULTILIB_USEDEP}] )
	nas? (
		>=media-libs/nas-1.9.4[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	)
	tslib? ( >=x11-libs/tslib-1.0-r3[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	sound? ( >=media-libs/audiofile-0.3.5[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	nas? ( x11-base/xorg-proto )
	X? ( x11-base/xorg-proto )"
BDEPEND="
	pulseaudio? ( virtual/pkgconfig )
	x86? (
		|| (
			>=dev-lang/yasm-0.6.0
			>=dev-lang/nasm-0.98.39-r3
		)
	)"

S=${WORKDIR}/SDL-1.2-${MY_COMMIT}

pkg_setup() {
	if use custom-cflags ; then
		ewarn "Since you've chosen to use possibly unsafe CFLAGS,"
		ewarn "don't bother filing libsdl-related bugs until trying to remerge"
		ewarn "libsdl without the custom-cflags use flag in USE."
	fi
}

PATCHES=(
	"${FILESDIR}"/${PN}-$(ver_cut 1-3)-sdl-config.patch
	"${FILESDIR}"/${PN}-$(ver_cut 1-3)-gamma.patch
)

DOCS=( BUGS CREDITS README-SDL.txt TODO WhatsNew )

HTML_DOCS=( {docs,VisualC}.html docs/{html,images,index.html} )

src_prepare() {
	default
	AT_M4DIR="${EPREFIX}/usr/share/aclocal acinclude" eautoreconf
}

multilib_src_configure() {
	local myconf=
	if use !x86 && use !x86-linux ; then
		myconf="${myconf} --disable-nasm"
	else
		myconf="${myconf} --enable-nasm"
	fi
	use custom-cflags || strip-flags
	use sound || myconf="${myconf} --disable-audio"
	use video \
		&& myconf="${myconf} --enable-video-dummy" \
		|| myconf="${myconf} --disable-video"
	use joystick || myconf="${myconf} --disable-joystick"

	ECONF_SOURCE="${S}" econf \
		$(use_enable prefix rpath) \
		--disable-arts \
		--disable-esd \
		--enable-events \
		--enable-cdrom \
		--enable-threads \
		--enable-timers \
		--enable-file \
		--enable-cpuinfo \
		--disable-alsa-shared \
		--disable-esd-shared \
		--disable-pulseaudio-shared \
		--disable-arts-shared \
		--disable-nas-shared \
		--disable-osmesa-shared \
		$(use_enable oss) \
		$(use_enable alsa) \
		$(use_enable pulseaudio) \
		$(use_enable nas) \
		$(use_enable X video-x11) \
		$(use_enable dga) \
		$(use_enable xv video-x11-xv) \
		$(use_enable xinerama video-x11-xinerama) \
		$(use_enable X video-x11-xrandr) \
		$(use_enable dga video-dga) \
		$(use_enable fbcon video-fbcon) \
		--disable-video-ggi \
		--disable-video-svga \
		$(use_enable aalib video-aalib) \
		$(use_enable libcaca video-caca) \
		$(use_enable opengl video-opengl) \
		--disable-video-ps3 \
		$(use_enable tslib input-tslib) \
		$(use_with X x) \
		$(use_enable static-libs static) \
		--disable-video-x11-xme \
		--disable-video-directfb \
		${myconf}
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	use static-libs || find "${ED}" -type f -name "*.la" -delete || die
	einstalldocs
}
