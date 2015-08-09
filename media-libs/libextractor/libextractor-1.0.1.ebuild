# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="A library used to extract metadata from files of arbitrary type"
HOMEPAGE="http://www.gnu.org/software/libextractor/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="+archive +bzip2 ffmpeg flac gif gsf gtk jpeg mp4 +magic midi mpeg qt4 tidy tiff vorbis +zlib" # test

RESTRICT="test"

RDEPEND="app-text/iso-codes
	>=dev-libs/glib-2
	media-gfx/exiv2
	sys-devel/libtool
	virtual/libiconv
	virtual/libintl
	archive? ( app-arch/libarchive )
	bzip2? ( app-arch/bzip2 )
	ffmpeg? ( virtual/ffmpeg )
	flac? (
		media-libs/flac
		media-libs/libogg
		)
	gif? ( media-libs/giflib )
	gsf? ( gnome-extra/libgsf )
	gtk? ( x11-libs/gtk+:3 )
	jpeg? ( virtual/jpeg )
	mp4? ( media-libs/libmp4v2:0 )
	magic? ( sys-apps/file )
	midi? ( media-libs/libsmf )
	mpeg? ( media-libs/libmpeg2 )
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtsvg:4
		)
	tidy? ( app-text/htmltidy )
	tiff? ( media-libs/tiff:0 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
		)
	zlib? ( sys-libs/zlib )
	!<app-crypt/pkcrack-1.2.2-r1
	!sci-biology/glimmer
	!sci-chemistry/pdb-extract"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"
# test? ( app-forensics/zzuf )

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	# m4/ax_create_pkgconfig_info.m4 is passing environment LDFLAGS to Libs:
	sed -i \
		-e '/^ax_create_pkgconfig_ldflags=/s:$LDFLAGS ::' \
		-e 's:ac_cv_header_tidy_tidy_h:ac_cv_header_tidy_h:g' \
		-e 's:tidy/tidy.h:tidy.h:g' \
		-e 's:tidy/buffio.h:buffio.h:g' \
		configure src/plugins/html_extractor.c || die
}

src_configure() {
	e_ac_cv() {
		export ac_cv_"$@"
	}

	e_ac_cv {lib_rpm_rpmReadPackageFile,prog_HAVE_ZZUF}=no

	if use flac; then
		e_ac_cv header_FLAC_all_h=yes
		e_ac_cv lib_FLAC_FLAC__stream_decoder_init_stream=yes
	else
		e_ac_cv header_FLAC_all_h=no
		e_ac_cv lib_FLAC_FLAC__stream_decoder_init_stream=no
		e_ac_cv lib_FLAC_FLAC__stream_decoder_init_ogg_stream=no
	fi

	e_ac_cv header_archive_h=$(usex archive)
	e_ac_cv header_bzlib_h=$(usex bzip2)
	e_ac_cv header_gif_lib_h=$(usex gif)
	e_ac_cv header_jpeglib_h=$(usex jpeg)
	e_ac_cv header_magic_h=$(usex magic)
	e_ac_cv header_mpeg2dec_mpeg2_h=$(usex mpeg)
	e_ac_cv header_tiffio_h=$(usex tiff)
	e_ac_cv header_vorbis_vorbisfile_h=$(usex vorbis)
	e_ac_cv header_zlib_h=$(usex zlib)
	e_ac_cv lib_tidy_tidyInitSource=$(usex tidy)
	e_ac_cv lib_mp4v2_MP4ReadProvider=$(usex mp4)
	e_ac_cv lib_smf_smf_load_from_memory=$(usex midi)

	local myconf

	if use qt4; then
		append-cppflags "$($(tc-getPKG_CONFIG) --cflags-only-I QtGui QtSvg)"
		append-ldflags "$($(tc-getPKG_CONFIG) --libs-only-L QtGui QtSvg)"
	else
		myconf='--without-qt'
	fi

	# gstreamer support is for 1.0, no 0.10 support
	econf \
		--disable-static \
		--enable-experimental \
		--enable-glib \
		$(use_enable gsf) \
		--disable-gnome \
		$(use_enable ffmpeg) \
		--with-gtk_version=$(usex gtk 3.0.0 false) \
		--without-gstreamer \
		${myconf}
}

src_compile() {
	emake -j1
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} +
}
