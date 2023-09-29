# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="A tool to read SMART information from harddiscs"
HOMEPAGE="http://www.linalco.com/comunidad.html http://www.linux-ide.org/smart.html"
SRC_URI="http://www.linalco.com/ragnar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

src_compile() {
	edo $(tc-getCC) ${CFLAGS} ${CPPFLAGS} -Wall ${LDFLAGS} -o ${PN} ${PN}.c
}

src_install() {
	dobin ide-smart
	doman ide-smart.8
	dodoc README
}
