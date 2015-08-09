# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="BlindWrite image to ISO image file converter"
HOMEPAGE="http://developer.berlios.de/projects/b5i2iso/"
SRC_URI="mirror://berlios/${PN}/${PN}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/${PN}

src_compile() {
	$(tc-getCC) ${LDFLAGS} ${CFLAGS} src/${PN}.c -o ${PN} || die
}

src_install() {
	dobin ${PN} || die
}
