# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iftop/iftop-1.0_pre4-r2.ebuild,v 1.2 2014/10/27 18:47:26 jer Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="display bandwidth usage on an interface"
SRC_URI="http://www.ex-parrot.com/pdw/iftop/download/${P/_/}.tar.gz"
HOMEPAGE="http://www.ex-parrot.com/pdw/iftop/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}"/${P/_/}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-configure.ac.patch \
		"${FILESDIR}"/${P}-Makefile.am.patch \
		"${FILESDIR}"/${P}-tsent-set-but-not-used.patch

	# bug 490168
	cat "${FILESDIR}"/ax_pthread.m4 >> "${S}"/acinclude.m4 || die

	eautoreconf
}

src_install() {
	dosbin iftop
	doman iftop.8

	dodoc AUTHORS ChangeLog README "${FILESDIR}"/iftoprc
}
