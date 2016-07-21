# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="compiler-compiler tool for aspect-oriented programming"
HOMEPAGE="https://www.gnu.org/software/dotgnu"
SRC_URI="http://download.savannah.gnu.org/releases/dotgnu-pnet/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="doc examples"

DEPEND="doc? ( app-text/texi2html )"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"

	if use doc ; then
		if [ ! -f "${S}"/doc/treecc.texi ] ; then
			die "treecc.texi was not generated"
		fi

		cd "${S}"/doc
		texi2html -split_chapter "${S}"/doc/treecc.texi \
			|| die "texi2html failed"
		cd "${S}"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README

	if use examples ; then
		docinto examples
		dodoc examples/README
		dodoc examples/{expr_c.tc,gram_c.y,scan_c.l}
	fi

	if use doc ; then
		dodoc doc/*.{txt,html}

		docinto html
		dohtml doc/treecc/*.html
	fi
}
