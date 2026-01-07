# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a toolchain-funcs

DESCRIPTION="Compiler-compiler tool for aspect-oriented programming"
HOMEPAGE="https://www.gnu.org/software/dotgnu/"
SRC_URI="https://download.savannah.gnu.org/releases/dotgnu-pnet/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~s390 ~sparc x86"
IUSE="doc examples"

DEPEND="doc? ( app-text/texi2html )"

PATCHES=(
	"${FILESDIR}/${P}-proto.patch"
)

src_configure() {
	lto-guarantee-fat
	default
}

src_compile() {
	emake AR="$(tc-getAR)"

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
	strip-lto-bytecode

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
