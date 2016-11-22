# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Server for Mednafen emulator"
HOMEPAGE="http://mednafen.fobby.net/releases/"
SRC_URI="http://mednafen.fobby.net/releases/files/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

S=${WORKDIR}/${PN}

src_prepare() {
	default

	mv standard.conf standard.conf.example || die
	mv run.sh run.sh.example || die
}

src_install() {
	dobin src/${PN}
	dodoc README *.example
}

pkg_postinst() {
	einfo "Example config file and run file can be found in"
	einfo "/usr/share/doc/${PF}/"
}
