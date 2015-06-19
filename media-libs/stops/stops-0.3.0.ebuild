# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/stops/stops-0.3.0.ebuild,v 1.3 2009/01/25 14:55:53 maekke Exp $

DESCRIPTION="Organ stops for aeolus by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/aeolus/index.html"
SRC_URI="http://users.skynet.be/solaris/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	insinto /usr/share/${PN}
	doins -r *.ae0 Aeolus* waves
}
