# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="Nyan Cat Telnet Server"
HOMEPAGE="https://github.com/klange/nyancat"
SRC_URI="https://github.com/klange/nyancat/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_compile() {
	emake LFLAGS="${LDFLAGS} ${CFLAGS}"
}

src_install() {
	dogamesbin src/${PN}
	dodoc README.md
	prepgamesdirs
}
