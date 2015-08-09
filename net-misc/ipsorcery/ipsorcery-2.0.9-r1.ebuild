# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Ipsorcery allows you to generate IP, TCP, UDP, ICMP, and IGMP packets"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/ipsorc-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

S=${WORKDIR}/ipsorc-${PV}

src_prepare() {
	sed -i \
		-e 's:-g -O2:$(LDFLAGS) $(CFLAGS):' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" con || die
}

src_install() {
	dosbin ipmagic || die
	dodoc BUGS changelog HOWTO README
}
