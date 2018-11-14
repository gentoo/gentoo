# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools desktop

DESCRIPTION="A heavily multi-threaded pluggable audio player"
HOMEPAGE="http://www.alsaplayer.org/"
SRC_URI="http://www.alsaplayer.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ~sparc x86"
IUSE="+alsa audiofile doc flac gtk id3tag jack mad mikmod nas nls ogg opengl oss vorbis xosd"

RDEPEND="
	media-libs/libsndfile:=
	sys-libs/zlib:=
	alsa? ( media-libs/alsa-lib )
	audiofile? ( media-libs/audiofile )
	flac? ( media-libs/flac )
	gtk? ( >=x11-libs/gtk+-2.10:2 )
	id3tag? ( media-libs/libid3tag )
	jack? ( >=media-sound/jack-audio-connection-kit-0.80 )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod:0 )
	nas? ( media-libs/nas )
	ogg? ( media-libs/libogg )
	opengl? ( virtual/opengl )
	vorbis? ( media-libs/libvorbis )
	xosd? ( x11-libs/xosd )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )
	oss? ( virtual/os-headers )"
REQUIRED_USE="|| ( alsa jack nas oss )"

src_prepare() {
	default

	sed -i \
		-e 's:AM_CFLAGS = $(AM_CXXFLAGS)::' \
		output/jack/Makefile.am || die

	sed -i \
		-e 's:-O2 -funroll-loops -finline-functions -ffast-math::' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	export ac_cv_prog_HAVE_DOXYGEN=$(usex doc true false)
	export ac_cv_lib_xosd_xosd_create=$(usex xosd)

	econf \
		--disable-esd \
		$(use_enable nls) \
		$(use_enable opengl) \
		$(use_enable mikmod) \
		$(use_enable vorbis oggvorbis) \
		$(use_enable audiofile) \
		$(use_enable flac) \
		$(use_enable mad) \
		$(use_enable id3tag) \
		$(use_enable gtk systray) \
		$(use_enable jack) \
		$(use_enable alsa) \
		$(use_enable oss) \
		$(use_enable gtk gtk2) \
		$(use_enable nas)
}

src_install() {
	default
	dodoc docs/*.txt

	newicon interface/gtk2/pixmaps/logo.xpm ${PN}.xpm

	find "${D}" -name '*.la' -delete || die
}
