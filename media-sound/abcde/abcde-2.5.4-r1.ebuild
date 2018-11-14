# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A command line CD encoder"
HOMEPAGE="https://code.google.com/p/abcde/"
SRC_URI="https://abcde.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
# Enable MP3 related flags by default
IUSE="aac cdparanoia cdr flac +id3tag +lame musicbrainz normalize replaygain speex vorbis"

# See `grep :: abcde-musicbrainz-tool` output for USE musicbrainz dependencies
RDEPEND="media-sound/cd-discid
	net-misc/wget
	virtual/eject
	aac? (
		media-libs/faac
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
	musicbrainz? (
		dev-perl/MusicBrainz-DiscID
		dev-perl/WebService-MusicBrainz
		virtual/perl-Digest-SHA
		virtual/perl-Getopt-Long
		)
	normalize? ( >=media-sound/normalize-0.7.4 )
	replaygain? (
		vorbis? ( media-sound/vorbisgain )
		lame? ( media-sound/mp3gain )
		)
	speex? ( media-libs/speex )
	vorbis? ( media-sound/vorbis-tools )"

src_prepare() {
	sed -i -e 's:etc/abcde.co:etc/abcde/abcde.co:g' abcde || die

	epatch "${FILESDIR}"/${P}-eyeD3-0.7-api.patch
}

src_install() {
	emake DESTDIR="${D}" etcdir="${D}"etc/abcde install

	dodoc changelog FAQ README TODO USEPIPES

	docinto examples
	dodoc examples/*
}
