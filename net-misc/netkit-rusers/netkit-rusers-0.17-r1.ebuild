# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-rusers/netkit-rusers-0.17-r1.ebuild,v 1.1 2010/12/31 18:40:32 jer Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Netkit - rup rpc.rusersd rusers"
HOMEPAGE="http://www.hcs.harvard.edu/~dholland/computers/netkit.html"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-include.patch
	sed -i configure -e '/^LDFLAGS=/d' || die "sed configure"
}

src_configure() {
	./configure --with-c-compiler=$(tc-getCC) || die
	sed -i MCONFIG -e "s:-O2::" -e "s:-Wpointer-arith::" || die "sed MCONFIG"
}

src_compile() {
	# see bug #244867 for parallel make issues
	emake -j1 || die
}

src_install() {
	into /usr
	dobin rup/rup
	doman rup/rup.1
	dobin rpc.rusersd/rusersd
	doman rpc.rusersd/rpc.rusersd.8
	dobin rusers/rusers
	doman rusers/rusers.1
	dodoc README ChangeLog
}
