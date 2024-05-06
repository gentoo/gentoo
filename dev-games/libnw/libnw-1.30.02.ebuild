# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tools and libraries for NWN file manipulation"
HOMEPAGE="https://sourceforge.net/projects/openknights"
SRC_URI="https://downloads.sourceforge.net/openknights/${P}.tar.gz"

LICENSE="openknights"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="!sci-biology/newick-utils"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex"

DOCS=( AUTHORS ChangeLog NEWS README README.tech TODO )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
