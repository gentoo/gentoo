# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/ide-smart/ide-smart-1.4-r1.ebuild,v 1.5 2012/01/05 22:12:11 xmw Exp $

inherit toolchain-funcs

DESCRIPTION="A tool to read SMART information from harddiscs"
HOMEPAGE="http://www.linalco.com/comunidad.html http://www.linux-ide.org/smart.html"
SRC_URI="http://www.linalco.com/ragnar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

src_compile() {
	$(tc-getCC) ${CFLAGS} -Wall ${LDFLAGS} -o ${PN} ${PN}.c || die "compile"
}

src_install() {
	dobin ide-smart || die
	doman ide-smart.8
	dodoc README
}
