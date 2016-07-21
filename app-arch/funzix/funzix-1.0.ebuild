# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="unpacker for the bogus ZIX format"
HOMEPAGE="http://funzix.sourceforge.net/"
SRC_URI="mirror://sourceforge/funzix/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin funzix || die
	dodoc README
}
