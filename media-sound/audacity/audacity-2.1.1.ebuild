# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audacity/audacity-2.1.1.ebuild,v 1.1 2015/07/20 15:21:39 yngwin Exp $

EAPI=5
inherit eutils wxwidgets

MY_P="${PN}-minsrc-${PV}"
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="http://web.audacityteam.org/"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${MY_P}.tar.xz
	doc? ( http://dev.gentoo.org/~yngwin/distfiles/${PN}-manual-${PV}.zip )"
	# wget doesn't seem to work on FossHub links, so we mirror

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~x86"
IUSE="alsa cpu_flags_x86_sse doc ffmpeg +flac id3tag jack +ladspa +lame libav
	+lv2 mad +midi nls +portmixer sbsms +soundtouch twolame vamp +vorbis +vst"
RESTRICT="test"

RDEPEND=">=app-arch/zip-2.3
	dev-libs/expat
	>=media-libs/libsndfile-1.0.0
	=media-libs/portaudio-19*
	media-libs/soxr
	x11-libs/wxGTK:2.8[X]
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( libav? ( media-video/libav:= )
		!libav? ( >=media-video/ffmpeg-1.2:= ) )
	flac? ( >=media-libs/flac-1.2.0[cxx] )
	id3tag? ( media-libs/libid3tag )
	jack? ( >=media-sound/jack-audio-connection-kit-0.103.0 )
	lame? ( >=media-sound/lame-3.70 )
	lv2? ( media-libs/lv2 )
	mad? ( >=media-libs/libmad-0.14.2b )
	midi? ( media-libs/portmidi )
	sbsms? ( media-libs/libsbsms )
	soundtouch? ( >=media-libs/libsoundtouch-1.3.1 )
	twolame? ( media-sound/twolame )
	vamp? ( >=media-libs/vamp-plugin-sdk-2.0 )
	vorbis? ( >=media-libs/libvorbis-1.0 )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

REQUIRED_USE="soundtouch? ( midi )"

S=${WORKDIR}/${MY_P}

#src_prepare() {
#	epatch "${FILESDIR}"/${P}-automagic.patch
#	AT_M4DIR="${S}/m4" eautoreconf
#}

src_configure() {
	WX_GTK_VER="2.8"
	need-wxwidgets unicode

	# * always use system libraries if possible
	# * options listed in the order that configure --help lists them
	econf \
		$(use_enable nls) \
		--enable-unicode \
		$(use_enable cpu_flags_x86_sse sse) \
		--disable-dynamic-loading \
		--enable-nyquist \
		$(use_enable ladspa) \
		$(use_enable vst) \
		--with-wx-version=${WX_GTK_VER} \
		--with-expat=system \
		$(use_with ffmpeg) \
		$(use_with lame) \
		$(use_with flac libflac) \
		$(use_with id3tag libid3tag) \
		$(use_with mad libmad) \
		$(use_with sbsms) \
		--with-libsndfile=system \
		$(use_with soundtouch) \
		--with-libsoxr=system \
		$(use_with twolame libtwolame) \
		$(use_with vamp libvamp) \
		$(use_with vorbis libvorbis) \
		$(use_with lv2) \
		--with-portaudio \
		$(use_with midi) \
		--with-widgetextra=local \
		$(use_with portmixer)
#		$(use_with alsa) \
#		$(use_with jack)
}

src_install() {
	emake DESTDIR="${D}" install

	# Remove bad doc install
	rm -rf "${D}"/usr/share/doc

	# Install our docs
	dodoc README.txt

	use doc && dohtml -r "${WORKDIR}"/help/manual
}
