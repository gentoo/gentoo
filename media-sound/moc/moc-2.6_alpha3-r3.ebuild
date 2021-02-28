# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN}-${PV/_/-}
DESCRIPTION="Music On Console - ncurses interface for playing audio files"
HOMEPAGE="https://moc.daper.net"
SRC_URI="http://ftp.daper.net/pub/soft/moc/unstable/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="aac alsa +cache curl debug ffmpeg flac jack libsamplerate mad +magic modplug musepack
	oss sid sndfile sndio speex timidity tremor +unicode vorbis wavpack"

RDEPEND="
	>=dev-libs/libltdl-2:0
	dev-libs/popt
	sys-libs/ncurses:0=[unicode?]
	aac? ( media-libs/faad2 )
	alsa? ( >=media-libs/alsa-lib-1.0.11 )
	cache? ( >=sys-libs/db-4.1:= )
	curl? ( >=net-misc/curl-7.15.1 )
	ffmpeg? ( >=media-video/ffmpeg-1.2.6-r1 )
	flac? ( >=media-libs/flac-1.1.3 )
	jack? ( virtual/jack )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.0 )
	mad? (
		media-libs/libmad
		sys-libs/zlib
		media-libs/libid3tag
	)
	magic? ( sys-apps/file )
	modplug? ( >=media-libs/libmodplug-0.7 )
	musepack? (
		media-sound/musepack-tools
		>=media-libs/taglib-1.5
	)
	sid? ( >=media-libs/libsidplay-2.1.1 )
	sndfile? ( >=media-libs/libsndfile-1.0.0 )
	sndio? ( media-sound/sndio )
	speex? ( >=media-libs/speex-1.0.0 )
	timidity? (
		>=media-libs/libtimidity-0.1.0
		media-sound/timidity++
	)
	vorbis? (
		>=media-libs/libogg-1.0
		tremor? ( media-libs/tremor )
		!tremor? ( >=media-libs/libvorbis-1.0 )
	)
	wavpack? ( >=media-sound/wavpack-4.31 )
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}
PATCHES=( "${FILESDIR}/ffmpeg4.patch" )

src_configure() {
	local myconf=(
		--without-rcc
		$(use_enable debug)
		$(use_enable cache)
		$(use_with oss)
		$(use_with alsa)
		$(use_with jack)
		$(use_with sndio)
		$(use_with magic)
		$(use_with unicode ncursesw)
		$(use_with libsamplerate samplerate)
		$(use_with aac)
		$(use_with ffmpeg)
		$(use_with flac)
		$(use_with modplug)
		$(use_with mad mp3)
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
	find "${D}" -name '*.la' -delete || die
}
