# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple thesaurus for LibreOffice"
HOMEPAGE="https://github.com/hunspell/mythes"
SRC_URI="https://github.com/hunspell/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="app-text/hunspell:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		--disable-werror \
		$(use_enable debug)
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
