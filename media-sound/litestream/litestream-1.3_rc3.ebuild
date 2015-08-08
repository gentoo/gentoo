# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic toolchain-funcs

MY_P=${P/_rc/RC}

DESCRIPTION="Litstream is a lightweight and robust shoutcast-compatible streaming mp3 server"
HOMEPAGE="http://www.litestream.org/"
SRC_URI="http://litestream.org/litestream/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:CFLAGS = :CFLAGS = ${OPTFLAGS} :; s:-g::' \
		Makefile || die "sed failed"
}

src_compile() {
	append-flags "-DNO_VARARGS"
	emake CC=$(tc-getCC) OPTFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin litestream literestream || die "dobin failed"
	newbin source litestream-source
	newbin server litestream-server
	newbin client litestream-client

	dodoc ABOUT ACKNOWLEDGEMENTS BUGS CHANGELOG CONTACT FILES MAKEITGO README
}
