# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Command line CD encoder"
HOMEPAGE="https://abcde.einval.com/"
SRC_URI="https://abcde.einval.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
# Enable MP3 related flags by default
IUSE="aac aiff cdr flac +id3tag +lame mac musepack musicbrainz normalize opus replaygain speex vorbis wavpack"

# See `grep :: abcde-musicbrainz-tool` output for USE musicbrainz dependencies
RDEPEND="
	media-sound/cd-discid
	net-misc/wget
	virtual/eject
	|| (
		dev-libs/libcdio-paranoia
		media-sound/cdparanoia
		media-sound/dagrab
	)
	aac? (
		media-libs/faac
		|| (
			media-video/atomicparsley
			media-video/atomicparsley-wez
		)
	)
	aiff? ( virtual/ffmpeg )
	cdr? ( virtual/cdrtools )
	flac? ( media-libs/flac )
	id3tag? (
		dev-python/eyeD3:0.7
		>=media-sound/id3-0.12
		media-sound/id3v2
	)
	lame? ( media-sound/lame )
	mac? (
		media-sound/apetag
		media-sound/mac
	)
	musepack? ( media-sound/musepack-tools )
	musicbrainz? (
		dev-perl/MusicBrainz-DiscID
		>=dev-perl/WebService-MusicBrainz-1.0.4
		virtual/perl-Digest-SHA
		virtual/perl-Getopt-Long
	)
	normalize? ( >=media-sound/normalize-0.7.4 )
	opus? ( media-sound/opus-tools )
	replaygain? (
		lame? ( media-sound/mp3gain )
		vorbis? ( media-sound/vorbisgain )
	)
	speex? ( media-libs/speex )
	vorbis? ( media-sound/vorbis-tools )
	wavpack? ( media-sound/wavpack )
"

PATCHES=( "${FILESDIR}/${P}-Makefile.patch" )

src_prepare() {
	default
	sed -e 's:etc/abcde.co:etc/abcde/abcde.co:g' -i abcde || die
	sed -e '/^prefix/s/=/?=/' -e '/^sysconfdir/s/=/?=/' -i Makefile || die
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" sysconfdir="/etc/abcde" install

	dodoc changelog FAQ README

	docinto examples
	dodoc examples/*
}
