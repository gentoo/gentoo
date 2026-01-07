# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Automatic algebraic manipulator"
HOMEPAGE="https://github.com/mfillpot/mathomatic"
SRC_URI="https://github.com/mfillpot/mathomatic/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="doc gnuplot"

DEPEND="
	sys-libs/readline:=
	sys-libs/ncurses:="
RDEPEND="${DEPEND}
	gnuplot? ( sci-visualization/gnuplot )"
BDEPEND="doc? ( app-text/htmldoc )"

src_compile() {
	append-cflags -DBOLD_COLOR=1
	emake READLINE=1 CC="$(tc-getCC)"
	emake CC="$(tc-getCC)" -C primes
	use doc && emake pdf
}

src_test() {
	default
	emake -C primes check
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}"/usr \
		mathdocdir="${EPREFIX}"/usr/share/doc/${PF} \
		bininstall m4install
	emake DESTDIR="${D}" prefix="${EPREFIX}"/usr -C primes install
	dodoc changes.txt README.txt AUTHORS
	newdoc primes/README.txt README-primes.txt
	use doc && emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}"/usr \
		mathdocdir="${EPREFIX}"/usr/share/doc/${PF} \
		docinstall
}
