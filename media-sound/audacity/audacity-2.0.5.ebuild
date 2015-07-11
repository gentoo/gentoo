# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audacity/audacity-2.0.5.ebuild,v 1.5 2015/07/11 19:08:40 zlogene Exp $

EAPI=5

inherit eutils wxwidgets autotools versionator

MY_PV=$(replace_version_separator 3 -)
MY_P="${PN}-src-${MY_PV}"
MY_T="${PN}-minsrc-${MY_PV}"
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="http://web.audacityteam.org/"
SRC_URI="mirror://gentoo/${MY_T}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ppc64 x86"
IUSE="alsa ffmpeg flac id3tag jack ladspa libsamplerate +libsoxr midi mp3 sbsms soundtouch twolame vamp vorbis"
RESTRICT="test"

COMMON_DEPEND="x11-libs/wxGTK:2.8[X]
	>=app-arch/zip-2.3
	>=media-libs/libsndfile-1.0.0
	dev-libs/expat
	libsamplerate? ( >=media-libs/libsamplerate-0.1.2 )
	libsoxr? ( media-libs/soxr )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	mp3? ( >=media-libs/libmad-0.14.2b )
	flac? ( >=media-libs/flac-1.2.0[cxx] )
	id3tag? ( media-libs/libid3tag )
	sbsms? ( media-libs/libsbsms )
	soundtouch? ( >=media-libs/libsoundtouch-1.3.1 )
	vamp? ( >=media-libs/vamp-plugin-sdk-2.0 )
	twolame? ( media-sound/twolame )
	ffmpeg? ( virtual/ffmpeg )
	alsa? ( media-libs/alsa-lib )
	jack? ( >=media-sound/jack-audio-connection-kit-0.103.0 )"
# Crashes at  startup here...
#	lv2? ( >=media-libs/slv2-0.6.0 )
# Disabled upstream ATM
#  ladspa? ( >=media-libs/liblrdf-0.4.0 )

RDEPEND="${COMMON_DEPEND}
	mp3? ( >=media-sound/lame-3.70 )"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

REQUIRED_USE="soundtouch? ( midi )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.3.13-automagic.patch

	AT_M4DIR="${S}/m4" eautoreconf
}

src_configure() {
	WX_GTK_VER="2.8"
	need-wxwidgets unicode

	# * always use system libraries if possible
	# * options listed in the order that configure --help lists them
	# * if libsamplerate not requested, use libresample instead.
	econf \
		--enable-unicode \
		--enable-nyquist \
		--disable-dynamic-loading \
		$(use_enable ladspa) \
		--with-libsndfile=system \
		--with-expat=system \
		$(use_with libsamplerate) \
		$(use_with !libsamplerate libresample) \
		$(use_with libsoxr) \
		$(use_with vorbis libvorbis) \
		$(use_with mp3 libmad) \
		$(use_with flac libflac) \
		$(use_with id3tag libid3tag) \
		$(use_with sbsms) \
		$(use_with soundtouch) \
		$(use_with vamp libvamp) \
		$(use_with twolame libtwolame) \
		$(use_with ffmpeg) \
		$(use_with midi) \
		$(use_with alsa) \
		$(use_with jack)
}

# $(use_with lv2 slv2) \
# $(use_with ladspa liblrdf) \

src_install() {
	emake DESTDIR="${D}" install

	# Remove bad doc install
	rm -rf "${D}"/usr/share/doc

	# Install our docs
	dodoc README.txt
}
