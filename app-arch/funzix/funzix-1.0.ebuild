# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="unpacker for the bogus ZIX format"
HOMEPAGE="http://funzix.sourceforge.net/"
SRC_URI="mirror://sourceforge/funzix/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-1.0-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin funzix
	einstalldocs
}
