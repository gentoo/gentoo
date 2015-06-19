# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/funzix/funzix-1.0.ebuild,v 1.4 2008/10/23 02:38:38 flameeyes Exp $

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
