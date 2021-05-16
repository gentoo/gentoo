# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="simple utility that will automatically generate header files"
HOMEPAGE="http://www.hwaci.com/sw/mkhdr/"
SRC_URI="
	http://www.hwaci.com/sw/mkhdr/makeheaders.c -> ${P}.c
	http://www.hwaci.com/sw/mkhdr/makeheaders.html -> ${P}.html"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

S=${WORKDIR}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -o ${PN} "${DISTDIR}"/${P}.c || die
}

src_install() {
	dobin ${PN}

	local HTML_DOCS=( "${DISTDIR}"/${P}.html )
	einstalldocs
}
