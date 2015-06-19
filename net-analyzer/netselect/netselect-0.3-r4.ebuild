# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netselect/netselect-0.3-r4.ebuild,v 1.1 2015/02/14 07:46:06 jer Exp $

EAPI=5
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Ultrafast implementation of ping"
HOMEPAGE="http://apenwarr.ca/netselect/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-bsd.patch" \
		"${FILESDIR}/${P}-glibc.patch"

	sed -i \
		-e "s:PREFIX =.*:PREFIX = ${ED}usr:" \
		-e "s:CFLAGS =.*:CFLAGS = -Wall -I. ${CFLAGS}:" \
		-e "s:LDFLAGS =.*:LDFLAGS = ${LDFLAGS}:" \
		-e '23,27d' \
		-e '34d' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install () {
	dobin netselect
	if ! use prefix ; then
		fowners root:wheel /usr/bin/netselect
		fperms 4711 /usr/bin/netselect
	fi
	dodoc ChangeLog HISTORY README*
}
