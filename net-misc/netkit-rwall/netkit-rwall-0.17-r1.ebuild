# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Netkit - rwall"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	sed \
		-e "s:-O2 -Wall:-Wall:" \
		-e "s:-Wpointer-arith::" \
		-i MCONFIG.in || die
	sed \
		-e '/^LDFLAGS=/d' \
		-i configure || die "sed configure"
}

src_configure() {
	./configure \
		--verbose \
		--with-c-compiler=$(tc-getCC) || die
}

src_install() {
	dobin rwall/rwall
	doman rwall/rwall.1 	rpc.rwalld/rpc.rwalld.8
	dosbin rpc.rwalld/rwalld
	dosym rpc.rwalld.8 /usr/share/man/man8/rwall.8
	dodoc README ChangeLog BUGS
}
