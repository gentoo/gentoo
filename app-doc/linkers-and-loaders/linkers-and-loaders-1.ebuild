# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="The Linkers and Loaders book"
HOMEPAGE="https://linker.iecc.com/"
SRC_URI="https://wh0rd.org/books/${P}.tar.lzma"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc"
RESTRICT="mirror bindist"

RDEPEND=""
DEPEND="app-arch/xz-utils"

S=${WORKDIR}

src_install() {
	dohtml *.html *.jpg
	dodoc *.pdf
	use doc && dodoc *.txt *.rtf
}
