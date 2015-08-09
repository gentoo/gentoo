# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=${P/_/-}
DESCRIPTION="Music On Console - ncurses interface for playing audio files"
HOMEPAGE="http://moc.daper.net"
SRC_URI="http://ftp.daper.net/pub/soft/moc/unstable/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="aac alsa +cache curl debug ffmpeg flac jack libsamplerate mad +magic modplug musepack
	oss sid sndfile speex timidity tremor +unicode vorbis wavpack"

RDEPEND=">=dev-libs/libltdl-2:0
	sys-libs/ncurses[unicode?]
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	cache? ( >=sys-libs/db-4 )
	curl? ( net-misc/curl )
	ffmpeg? ( virtual/ffmpeg )
	flac? ( media-libs/flac )
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad sys-libs/zlib media-libs/libid3tag )
	magic? ( sys-apps/file )
	modplug? ( media-libs/libmodplug )
	musepack? ( media-sound/musepack-tools media-libs/taglib )
	sid? ( >=media-libs/libsidplay-2 )
	sndfile? ( media-libs/libsndfile )
	speex? ( media-libs/speex )
	timidity? ( media-libs/libtimidity media-sound/timidity++ )
	vorbis? (
		media-libs/libogg
		tremor? ( media-libs/tremor )
		!tremor? ( media-libs/libvorbis )
	)
	wavpack? ( media-sound/wavpack )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_configure() {
	local myconf=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable debug)
		$(use_enable cache)
		$(use_with oss)
		$(use_with alsa)
		$(use_with jack)
		$(use_with magic)
		$(use_with unicode ncursesw)
		$(use_with libsamplerate samplerate)
		$(use_with aac)
		$(use_with ffmpeg)
		$(use_with flac)
		$(use_with modplug)
		$(use_with mad mp3)
		--without-rcc
		$(use_with musepack)
		$(use_with sid sidplay2)
		$(use_with sndfile)
		$(use_with speex)
		$(use_with timidity)
		$(use_with vorbis vorbis $(usex tremor tremor ""))
		$(use_with wavpack)
		$(use_with curl)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} +
}
