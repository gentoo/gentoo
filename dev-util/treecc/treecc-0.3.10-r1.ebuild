# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Compiler-compiler tool for aspect-oriented programming"
HOMEPAGE="https://www.gnu.org/software/dotgnu"
SRC_URI="https://download.savannah.gnu.org/releases/dotgnu-pnet/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="doc examples"

DEPEND="doc? ( app-text/texi2html )"

src_compile() {
	default

	if use doc; then
		[[ -f "${S}"/doc/treecc.texi ]] || die "treecc.texi was not generated"
		cd "${S}"/doc || die
		texi2html -split_chapter "${S}"/doc/treecc.texi \
			|| die "texi2html failed"
		cd "${S}" || die
	fi
}

src_install() {
	default

	if use examples; then
		docinto examples
		dodoc examples/README
		dodoc examples/{expr_c.tc,gram_c.y,scan_c.l}
	fi

	if use doc; then
		dodoc doc/*.{txt,html}
		docinto html
		dodoc -r doc/treecc/*.html
	fi
}
