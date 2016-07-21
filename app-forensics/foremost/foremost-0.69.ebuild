# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="A console program to recover files based on their headers and footers"
HOMEPAGE="http://foremost.sourceforge.net/"
SRC_URI="http://foremost.sourceforge.net/pkg/${P}.tar.gz"

KEYWORDS="~amd64 ppc x86"
IUSE=""
LICENSE="public-domain"
SLOT="0"

src_compile() {
	emake CC_OPTS="${CFLAGS}" CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin foremost || die "dobin failed"
	doman foremost.1
	dodoc foremost.conf README CHANGES TODO
}
