# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Linkers and Loaders book"
HOMEPAGE="https://linker.iecc.com/"
SRC_URI="https://wh0rd.org/books/${P}.tar.lzma"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="doc"
RESTRICT="mirror bindist"

BDEPEND="app-arch/xz-utils"

S=${WORKDIR}

src_install() {
	use doc && dodoc *.txt *.rtf
	dodoc *.pdf
	docinto html
	dodoc *.html *.jpg
}
