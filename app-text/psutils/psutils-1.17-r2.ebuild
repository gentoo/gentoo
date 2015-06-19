# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/psutils/psutils-1.17-r2.ebuild,v 1.12 2013/04/14 11:47:20 ago Exp $

EAPI=3

inherit toolchain-funcs eutils

DESCRIPTION="PostScript Utilities"
HOMEPAGE="http://web.archive.org/web/20110722005140/http://www.tardis.ed.ac.uk/~ajcd/psutils/"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.dfsg.orig.tar.gz"

LICENSE="psutils"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}/${P}.orig"

src_prepare() {
	epatch "${FILESDIR}/${P}-ldflags.patch"
	epatch "${FILESDIR}/${P}-no-fixmacps.patch"
	sed \
		-e "s:/usr/local:\$(DESTDIR)${EPREFIX}/usr:" \
		"${S}/Makefile.unix" > "${S}/Makefile"
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install () {
	dodir /usr/{bin,share/man}
	emake DESTDIR="${D}" install || die
	dodoc README
}
