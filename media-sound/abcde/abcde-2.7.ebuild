# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/abcde/abcde-2.7.ebuild,v 1.1 2015/07/10 04:00:37 radhermit Exp $

EAPI=5

DESCRIPTION="A command line CD encoder"
HOMEPAGE="http://abcde.einval.com/"
SRC_URI="http://abcde.einval.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	sed -i 's:etc/abcde.co:etc/abcde/abcde.co:g' abcde || die
}

src_install() {
	emake DESTDIR="${D}" etcdir="${D}"etc/abcde install

	dodoc changelog FAQ README

	docinto examples
	dodoc examples/*
}
