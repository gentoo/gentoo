# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/arc/arc-5.21p.ebuild,v 1.7 2011/02/12 17:51:58 armin76 Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Create & extract files from DOS .ARC files"
HOMEPAGE="http://arc.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P/p/m}-darwin.patch \
		"${FILESDIR}"/${P/p/m}-gentoo-fbsd.patch \
		"${FILESDIR}"/${P/p/o}-interix.patch
	sed -i Makefile \
		-e 's/CFLAGS = $(OPT) $(SYSTEM)/CFLAGS += $(SYSTEM)/' \
		|| die "sed Makefile"
}

src_compile() {
	emake CC="$(tc-getCC)" OPT="${LDFLAGS}" || die "emake failed."
}

src_install() {
	dobin arc marc
	doman arc.1
	dodoc Arc521.doc Arcinfo Changelog Readme
}
