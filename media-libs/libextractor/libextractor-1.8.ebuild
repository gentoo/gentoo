# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library to extract metadata from files of arbitrary type"
HOMEPAGE="https://www.gnu.org/software/libextractor/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="apparmor +archive +bzip2 ffmpeg flac gif gsf gstreamer gtk jpeg +magic midi mp4 mpeg tidy tiff vorbis +zlib" # test

RESTRICT="test"

DEPEND="
	app-text/iso-codes
	dev-libs/glib:2
	media-gfx/exiv2:=
	sys-devel/libtool
	virtual/libiconv
	virtual/libintl
	apparmor? ( sys-libs/libapparmor )
	archive? ( app-arch/libarchive:= )
	bzip2? ( app-arch/bzip2 )
	ffmpeg? ( virtual/ffmpeg )
	flac? (
		media-libs/flac
		media-libs/libogg
	)
	gif? ( media-libs/giflib:= )
	gsf? ( gnome-extra/libgsf:= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	gtk? ( x11-libs/gtk+:3 )
	jpeg? ( virtual/jpeg:0 )
	magic? ( sys-apps/file )
	midi? ( media-libs/libsmf )
	mp4? ( media-libs/libmp4v2:0 )
	mpeg? ( media-libs/libmpeg2 )
	tidy? ( app-text/htmltidy )
	tiff? ( media-libs/tiff:0 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	zlib? ( sys-libs/zlib )
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
# test? ( app-forensics/zzuf )
RDEPEND="${DEPEND}
	!sci-biology/glimmer
"

src_prepare() {
	default

	# m4/ax_create_pkgconfig_info.m4 is passing environment LDFLAGS to Libs:
	sed -i \
		-e '/^ax_create_pkgconfig_ldflags=/s:$LDFLAGS ::' \
		-e 's:tidy/tidy.h:tidy.h:' \
		-e 's:tidy/tidybuffio.h:buffio.h:' \
		configure src/plugins/html_extractor.c || die

	if ! use tidy; then
		sed -i -e 's:tidy.h:dIsAbLe&:' configure || die
	fi
}

src_configure() {
	e_ac_cv() {
		export ac_cv_"$@"
	}

	e_ac_cv {lib_rpm_rpmReadPackageFile,prog_HAVE_ZZUF}=no

	e_ac_cv header_FLAC_all_h=$(usex flac)
	e_ac_cv lib_FLAC_FLAC__stream_decoder_init_stream=$(usex flac)
	e_ac_cv lib_FLAC_FLAC__stream_decoder_init_ogg_stream=$(usex flac)

	e_ac_cv header_sys_apparmor_h=$(usex apparmor)
	e_ac_cv header_archive_h=$(usex archive)
	e_ac_cv header_bzlib_h=$(usex bzip2)
	e_ac_cv header_gif_lib_h=$(usex gif)
	e_ac_cv header_jpeglib_h=$(usex jpeg)
	e_ac_cv header_magic_h=$(usex magic)
	e_ac_cv header_mpeg2dec_mpeg2_h=$(usex mpeg)
	e_ac_cv header_tiffio_h=$(usex tiff)
	e_ac_cv header_vorbis_vorbisfile_h=$(usex vorbis)
	e_ac_cv header_zlib_h=$(usex zlib)
	e_ac_cv lib_mp4v2_MP4ReadProvider=$(usex mp4)
	e_ac_cv lib_smf_smf_load_from_memory=$(usex midi)

	local myeconfargs=(
		--disable-static
		--enable-experimental
		--enable-glib
		--disable-gsf-gnome
		$(use_enable ffmpeg)
		$(use_enable gsf)
		$(use_with gstreamer)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
