# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rip/rip-1.07.ebuild,v 1.17 2007/06/12 18:11:11 aballier Exp $

IUSE=""

DESCRIPTION="A command-line based audio CD ripper and mp3 encoder"
SRC_URI="http://rip.sourceforge.net/download/${P}.tar.gz"
HOMEPAGE="http://rip.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 sparc x86"

DEPEND=""

RDEPEND="media-sound/cdparanoia
	virtual/eject
	dev-lang/perl
	>=dev-perl/CDDB_get-2.10
	>=dev-perl/MP3-Info-0.91
	|| ( media-sound/vorbis-tools media-sound/lame media-libs/flac media-sound/bladeenc media-sound/gogo )"

src_compile() {
	#the thing itself is just a perl script
	#so we need an empty method here
	echo "nothing to be done"

}

src_install () {

	chmod 755 rip
	dobin rip || die

	# Install documentation.
	dodoc FAQ README
}
