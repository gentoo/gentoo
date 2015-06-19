# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/makeheaders/makeheaders-0_p4.ebuild,v 1.4 2012/05/18 11:59:54 xmw Exp $

EAPI=3

inherit toolchain-funcs

DESCRIPTION="simple utility that will automatically generate header files"
HOMEPAGE="http://www.hwaci.com/sw/mkhdr/"
SRC_URI="http://www.hwaci.com/sw/mkhdr/makeheaders.c -> ${P}.c
	http://www.hwaci.com/sw/mkhdr/makeheaders.html -> ${P}.html"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	local my_a
	for my_a in ${A} ; do
		cp -v "${DISTDIR}"/"${my_a}" . || die
	done
}

src_compile() {
	$(tc-getCC) ${CFLAGS} -o ${PN} ${P}.c ${LDFLAGS} || die
}

src_install() {
	dobin ${PN} || die
	dohtml ${P}.html || die
}
