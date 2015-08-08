# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="A collection of Perl-scripts for iPod"
HOMEPAGE="http://www.gnu.org/software/gnupod/"
SRC_URI="http://blinkenlights.ch/gnupod-dist/stable/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="aac ffmpeg flac mp3 ogg"

RDEPEND="dev-perl/TimeDate
	dev-perl/XML-Parser
	>=dev-perl/MP3-Info-1.01
	dev-perl/Unicode-String
	dev-perl/Digest-SHA1
	dev-perl/libwww-perl
	ffmpeg?	( virtual/ffmpeg )
	flac?	( dev-perl/Audio-FLAC-Header
			  media-libs/flac
			  aac?  ( >=media-libs/faac-1.24 )
			  mp3?  ( media-sound/lame )
			  !aac? ( media-sound/lame ) )
	ogg?	( dev-perl/Ogg-Vorbis-Header-PurePerl
			  media-sound/vorbis-tools
			  aac?  ( >=media-libs/faac-1.24 )
			  mp3?  ( media-sound/lame )
			  !aac? ( media-sound/lame ) )"
DEPEND="${RDEPEND}"

src_configure() {
	econf
}

src_install() {
	perl_set_version
	sed -i -e "s:\$INC\[0\]/\$modi:${D}${VENDOR_ARCH}/\$modi:g" \
		tools/gnupod_install.pl || die

	dodir /usr/bin
	dodir ${VENDOR_ARCH}/GNUpod
	dodir /usr/share/info
	einstall

	dodoc CHANGES README* doc/gnupodrc.example doc/gnutunesdb.example
	dohtml doc/gnupod.html
}
