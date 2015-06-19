# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sox/sox-14.4.2.ebuild,v 1.8 2015/05/31 10:43:00 maekke Exp $

EAPI=5

inherit autotools

DESCRIPTION="The swiss army knife of sound processing programs"
HOMEPAGE="http://sox.sourceforge.net"
SRC_URI="mirror://sourceforge/sox/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 hppa ~mips ppc ppc64 sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="alsa amr ao debug encode flac id3tag ladspa mad ogg openmp oss opus png pulseaudio sndfile static-libs twolame wavpack"

RDEPEND="
	dev-libs/libltdl:0=
	>=media-sound/gsm-1.0.12-r1
	alsa? ( media-libs/alsa-lib )
	amr? ( media-libs/opencore-amr )
	ao? ( media-libs/libao )
	encode? ( >=media-sound/lame-3.98.4 )
	flac? ( >=media-libs/flac-1.1.3 )
	id3tag? ( media-libs/libid3tag )
	ladspa? ( media-libs/ladspa-sdk )
	mad? ( media-libs/libmad )
	ogg? ( media-libs/libvorbis	media-libs/libogg )
	opus? ( media-libs/opus media-libs/opusfile )
	png? ( media-libs/libpng:0= sys-libs/zlib )
	pulseaudio? ( media-sound/pulseaudio )
	sndfile? ( >=media-libs/libsndfile-1.0.11 )
	twolame? ( media-sound/twolame )
	wavpack? ( media-sound/wavpack )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	sed -i -e 's:CFLAGS="-g":CFLAGS="$CFLAGS -g":' configure.ac || die #386027

	eautoreconf
}

src_configure() {
	econf \
		$(use_with alsa) \
		$(use_with amr amrnb) \
		$(use_with amr amrwb) \
		$(use_with ao) \
		$(use_enable debug) \
		$(use_with encode lame) \
		$(use_with flac) \
		$(use_with id3tag) \
		$(use_with ladspa) \
		$(use_with mad) \
		$(use_enable openmp) \
		$(use_with ogg oggvorbis) \
		$(use_with oss) \
		$(use_with opus) \
		$(use_with png) \
		$(use_with pulseaudio) \
		$(use_with sndfile) \
		$(use_enable static-libs static) \
		$(use_with twolame) \
		$(use_with wavpack) \
		--with-distro="Gentoo"
}

src_install() {
	default
	# libltdl is used for loading plugins, keeping libtool files with empty
	# dependency_libs what otherwise would be -exec rm -f {} +
	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} +
}
