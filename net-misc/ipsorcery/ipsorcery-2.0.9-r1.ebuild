# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ipsorcery/ipsorcery-2.0.9-r1.ebuild,v 1.6 2011/01/10 19:35:50 ranger Exp $

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
