# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs eutils

MY_PV=${PV/_beta/b}

DESCRIPTION="Tool for extracting and creating optimised Xbox ISO images"
HOMEPAGE="http://sourceforge.net/projects/extract-xiso"
SRC_URI="mirror://sourceforge/extract-xiso/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.7.1-headers.patch
	sed -i \
		-e 's:__LINUX__:__linux__:' \
		*.[ch] */*.[ch] || die
}

doit() { echo "$@"; "$@"; }

src_compile() {
	# Need _GNU_SOURCE here for asprintf prototype.
	doit $(tc-getCC) ${CFLAGS} ${CPPFLAGS} -D_GNU_SOURCE ${LDFLAGS} \
		extract-xiso.c libftp-*/*.c -o extract-xiso || die
}

src_install() {
	dobin extract-xiso
	dodoc README.TXT
}
