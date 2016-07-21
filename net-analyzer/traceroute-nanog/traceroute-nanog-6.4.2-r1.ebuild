# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

MY_P="${PN}_${PV}"
DEB_PL="1"
DESCRIPTION="Traceroute with AS lookup, TOS support, MTU discovery and other features"
HOMEPAGE="http://packages.debian.org/traceroute-nanog"
SRC_URI="
	https://dev.gentoo.org/~jer/${MY_P}.orig.tar.gz
	https://dev.gentoo.org/~jer/${MY_P}-${DEB_PL}.diff.gz
"
RESTRICT="mirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

S="${S}.orig"

src_prepare() {
	EPATCH_SUFFIX="dpatch" epatch \
		"${WORKDIR}/${MY_P}-${DEB_PL}.diff" \
		"${WORKDIR}/${P}.orig/${P}/debian/patches/"
}

src_compile() {
	$(tc-getCC) traceroute.c -o ${PN} ${CFLAGS} -DSTRING ${LDFLAGS} -lresolv -lm \
		|| die
}

src_install() {
	dosbin traceroute-nanog
	dodoc 0_readme.txt faq.txt
	newman ${P}/debian/traceroute-nanog.genuine.8 traceroute-nanog.8
}
