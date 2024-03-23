# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic xdg

DESCRIPTION="A heavily multi-threaded pluggable audio player"
HOMEPAGE="https://alsaplayer.sourceforge.net/"
SRC_URI="https://alsaplayer.sourceforge.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ~riscv ~sparc x86"
IUSE="+alsa audiofile doc flac gtk id3tag jack mad mikmod nas nls ogg opengl oss vorbis xosd"
REQUIRED_USE="|| ( alsa jack nas oss )"

RDEPEND="
	media-libs/libsndfile:=
	sys-libs/zlib:=
	alsa? ( media-libs/alsa-lib )
	audiofile? ( media-libs/audiofile:= )
	flac? ( media-libs/flac:= )
	gtk? ( >=x11-libs/gtk+-2.10:2 )
	id3tag? ( media-libs/libid3tag:= )
	jack? ( virtual/jack )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod:0 )
	nas? ( media-libs/nas )
	ogg? ( media-libs/libogg )
	opengl? ( virtual/opengl )
	vorbis? ( media-libs/libvorbis )
	xosd? ( x11-libs/xosd )"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-text/doxygen )"

PATCHES=( "${FILESDIR}"/${P}-autotools.patch )

src_prepare() {
	default
	cp "${BROOT}"/usr/share/gettext/config.rpath . || die
	eautoreconf
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/860423
	# https://github.com/alsaplayer/alsaplayer/issues/28
	filter-lto

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

	find "${ED}" -name '*.la' -delete || die
}
