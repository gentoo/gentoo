# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit toolchain-funcs

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
	default
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin mrouted
	dosbin mtrace mrinfo map-mbone
	doman mrouted.8 mtrace.8 mrinfo.8 map-mbone.8

	insinto /etc
	doins mrouted.conf
	newinitd "${FILESDIR}"/mrouted.rc mrouted
}
