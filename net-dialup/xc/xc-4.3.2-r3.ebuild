# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/xc/xc-4.3.2-r3.ebuild,v 1.11 2014/04/19 01:43:09 kumba Exp $

EAPI=5

inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="Modem dialout & serial terminal program"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/apps/serialcomm/dialout/"
SRC_URI="http://www.ibiblio.org/pub/Linux/apps/serialcomm/dialout/${P}.tar.gz"

LICENSE="xc-radley"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-implicit-decl.patch
	epatch "${FILESDIR}"/${P}-add-115200.patch

	sed -i \
		-e "/^libdir/s:/lib/:/$(get_libdir)/:" \
		-e "/strip/d" \
		Makefile || die
	# bug 459796
	append-libs "$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_compile() {
	tc-export AR CC RANLIB
	emake WARN="" all
}

src_install() {
	default
	insinto /usr/$(get_libdir)/xc
	doins phonelist xc.init dotfiles/.[a-z]*
}
