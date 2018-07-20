# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A command line CD encoder"
HOMEPAGE="https://abcde.einval.com/"
SRC_URI="https://abcde.einval.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
# Enable MP3 related flags by default
IUSE="aac cdparanoia cdr flac +id3tag +lame mac musepack musicbrainz normalize opus replaygain speex vorbis wavpack"

# See `grep :: abcde-musicbrainz-tool` output for USE musicbrainz dependencies
RDEPEND="media-sound/cd-discid
	net-misc/wget
	virtual/eject
	aac? (
		|| ( media-libs/faac media-sound/neroaac )
		|| ( media-video/atomicparsley media-video/atomicparsley-wez )
		)
	cdparanoia? (
		|| ( dev-libs/libcdio-paranoia media-sound/cdparanoia )
		)
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
		dev-perl/WebService-MusicBrainz
		virtual/perl-Digest-SHA
		virtual/perl-Getopt-Long
		)
	normalize? ( >=media-sound/normalize-0.7.4 )
	opus? ( media-sound/opus-tools )
	replaygain? (
		vorbis? ( media-sound/vorbisgain )
		lame? ( media-sound/mp3gain )
		)
	speex? ( media-libs/speex )
	vorbis? ( media-sound/vorbis-tools )
	wavpack? ( media-sound/wavpack )
"

src_prepare() {
	default
	sed -i 's:etc/abcde.co:etc/abcde/abcde.co:g' abcde || die
	sed -i -e '/^prefix/s/=/?=/' -e '/^sysconfdir/s/=/?=/' Makefile || die
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" sysconfdir="/etc/abcde" install

	dodoc changelog FAQ README

	docinto examples
	dodoc examples/*
}
