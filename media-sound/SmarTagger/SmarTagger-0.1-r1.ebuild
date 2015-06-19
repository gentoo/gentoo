# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/SmarTagger/SmarTagger-0.1-r1.ebuild,v 1.4 2007/07/30 13:41:45 gustavoz Exp $

inherit eutils

DESCRIPTION="Perl script for renaming and tagging mp3s"
HOMEPAGE="http://freshmeat.net/projects/smartagger/"
SRC_URI="http://freshmeat.net/redir/smartagger/9680/url_tgz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/MP3-Info"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	dobin ${PN}
	dosym ${PN} /usr/bin/smartagger
	dodoc changelog README TODO
	newdoc album.id3 example.id3
}
