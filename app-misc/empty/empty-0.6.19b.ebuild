# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils toolchain-funcs

DESCRIPTION="Small shell utility, similar to expect(1)"
HOMEPAGE="http://empty.sourceforge.net"
SRC_URI="mirror://sourceforge/empty/${P}.tgz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE="examples"
DEPEND=""
RDEPEND="virtual/logger"

src_prepare() {
	epatch "${FILESDIR}/overflow-fixes.patch"
	epatch "${FILESDIR}/${PN}-respect-LDFLAGS.patch"
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin empty
	doman empty.1
	dodoc README
	use examples && dodoc -r examples
}
