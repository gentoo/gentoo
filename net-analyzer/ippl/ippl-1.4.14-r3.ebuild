# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs user

DESCRIPTION="A daemon which logs TCP/UDP/ICMP packets"
HOMEPAGE="http://pltplp.net/ippl/"
SRC_URI="http://pltplp.net/ippl/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/yacc
	>=sys-devel/flex-2.5.4a-r4"
RDEPEND=""

src_prepare() {
	epatch \
		"${FILESDIR}"/ippl-1.4.14-noportresolve.patch \
		"${FILESDIR}"/ippl-1.4.14-manpage.patch \
		"${FILESDIR}"/ippl-1.4.14-privilege-drop.patch \
		"${FILESDIR}"/ippl-1.4.14-includes.patch
	sed -i Source/Makefile.in \
		-e 's|^LDFLAGS=|&@LDFLAGS@|g' \
		|| die "sed Source/Makefile.in"
	sed -i Makefile.in \
		-e 's|make |$(MAKE) |g' \
		|| die "sed Makefile.in"
	# fix for bug #351287
	sed -i -e '/lex.yy.c/s/ippl.l/& y.tab.c/' Source/Makefile.in \
		|| die "sed src/Makefile.in"
	tc-export CC
}

src_install() {
	dosbin Source/ippl

	insinto "/etc"
	doins ippl.conf

	doman Docs/{ippl.8,ippl.conf.5}

	dodoc BUGS CREDITS HISTORY README TODO

	newinitd "${FILESDIR}"/ippl.rc ippl
}

pkg_postinst() {
	enewuser ippl
}
