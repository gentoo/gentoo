# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-rwho/netkit-rwho-0.17-r4.ebuild,v 1.8 2015/05/25 09:58:42 vapier Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Netkit - ruptime/rwho/rwhod"
HOMEPAGE="http://www.hcs.harvard.edu/~dholland/computers/netkit.html"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${P}.tar.gz
	https://dev.gentoo.org/~jer/${P}-patches.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~mips ppc s390 sh sparc x86"
IUSE=""

src_prepare() {
	epatch "${WORKDIR}"/000{1,2,3,4}-*.patch
	epatch "${FILESDIR}"/${P}-printf.patch #529974
}

src_configure() {
	# Not an autotools build system
	./configure --with-c-compiler=$(tc-getCC) || die
	sed -i \
		-e "s:-O2::" \
		-e "s:-Wpointer-arith::" \
		MCONFIG || die
}

src_install() {
	keepdir /var/spool/rwho

	into /usr
	dobin ruptime/ruptime rwho/rwho
	dosbin rwhod/rwhod

	doman ruptime/ruptime.1 rwho/rwho.1 rwhod/rwhod.8
	dodoc README ChangeLog

	newinitd "${FILESDIR}"/${P}-rc rwhod
	newconfd "${FILESDIR}"/${P}-confd rwhod

	exeinto /etc/cron.monthly
	doexe "${FILESDIR}"/${P}-cron
}
