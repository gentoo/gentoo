# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Unpacker for the bogus ZIX format"
HOMEPAGE="https://funzix.sourceforge.io/"
SRC_URI="mirror://sourceforge/funzix/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.0-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin funzix
	einstalldocs
}
