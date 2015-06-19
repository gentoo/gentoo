# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/mathomatic/mathomatic-15.8.5.ebuild,v 1.4 2012/07/10 18:03:44 ranger Exp $

EAPI=4
inherit toolchain-funcs flag-o-matic

DESCRIPTION="Automatic algebraic manipulator"
HOMEPAGE="http://www.mathomatic.org/"
SRC_URI="${HOMEPAGE}/archive/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc gnuplot"

DEPEND="sys-libs/readline
	sys-libs/ncurses"
RDEPEND="${DEPEND}
	gnuplot? ( sci-visualization/gnuplot )"

src_compile() {
	append-cflags -DBOLD_COLOR=1
	emake READLINE=1 CC=$(tc-getCC)
	emake CC=$(tc-getCC) -C primes
}

src_test() {
	default
	emake -C primes check
}

src_install() {
	emake prefix="${EPREFIX}usr" DESTDIR="${D}" bininstall
	emake prefix="${EPREFIX}usr" DESTDIR="${D}" -C primes install
	dodoc changes.txt README.txt AUTHORS
	newdoc primes/README.txt README-primes.txt
	use doc && emake \
		prefix="${EPREFIX}usr" \
		mathdocdir="${EPREFIX}usr/share/doc/${PF}" \
		DESTDIR="${D}" docinstall
}
