# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/mrouted/mrouted-3.9.5.ebuild,v 1.5 2012/07/12 15:54:33 axs Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="IP multicast routing daemon"
HOMEPAGE="http://troglobit.com/mrouted.shtml"
SRC_URI="ftp://ftp.vmlinux.org/pub/People/jocke/${PN}/${P}.tar.bz2"
LICENSE="Stanford GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="|| ( dev-util/yacc sys-devel/bison )"
RDEPEND=""

src_prepare() {
	# Respect user CFLAGS, remove upstream optimisation and -Werror
	sed -i Makefile \
		-e '/^CFLAGS/{s|[[:space:]]=| +=|g;s|-O2||g;s|-Werror||g}' \
		|| die
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	dobin mrouted || die
	dosbin mtrace mrinfo map-mbone || die
	doman mrouted.8 mtrace.8 mrinfo.8 map-mbone.8 || die

	insinto /etc
	doins mrouted.conf || die
	newinitd "${FILESDIR}"/mrouted.rc mrouted || die
}
