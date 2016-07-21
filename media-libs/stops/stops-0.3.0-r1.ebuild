# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Organ stops for aeolus by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/aeolus/index.html"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	insinto /usr/share/${PN}
	doins -r *.ae0 Aeolus* waves
}
