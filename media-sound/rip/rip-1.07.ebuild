# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A command-line based audio CD ripper and mp3 encoder"
SRC_URI="http://rip.sourceforge.net/download/${P}.tar.gz"
HOMEPAGE="http://rip.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

RDEPEND="media-sound/cdparanoia
	virtual/eject
	dev-lang/perl
	>=dev-perl/CDDB_get-2.10
	>=dev-perl/MP3-Info-0.91
	|| ( media-sound/vorbis-tools media-sound/lame media-libs/flac media-sound/bladeenc )"

src_install () {
	dobin rip
	einstalldocs
}
