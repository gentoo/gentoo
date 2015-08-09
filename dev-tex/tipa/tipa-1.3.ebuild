# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="International Phonetic Alphabet package for LaTeX"
HOMEPAGE="http://www.l.u-tokyo.ac.jp/~fkr/"
SRC_URI="http://www.l.u-tokyo.ac.jp/~fkr/tipa/${P}.tar.gz"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

DEPEND="virtual/latex-base"
RDEPEND="${DEPEND}"

src_compile() {
	# install files under /usr/share/texmf/
	sed -e 's@PREFIX=/usr/local/teTeX/share/texmf@PREFIX=/usr/share/texmf@' \
		-i Makefile || die "sed failed"

	sed -e 's/\($(TEXDIR)\)/$(DESTDIR)\/\1/' \
		-e 's/\($(FONTDIR)\)/$(DESTDIR)\/\1/g' \
		-e 's/\($(MAPDIR)\)/$(DESTDIR)\/\1/' \
		-i Makefile || die "sed failed"

	# removing `mktexlsr` from Makefile (leads to access violation)
	sed -e 's/-mktexlsr//' -i Makefile || die "sed failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed."
	dodoc doc/*.{tex,sty,bib,bbl} || die "dodoc failed."

	elog "A huge documentation can be found in '/usr/share/doc/${P}'."
}

pkg_postinst() {
	einfo "Running mktexlsr..."
	mktexlsr || die "mktexlsr failed"

	elog
	elog "Append the line"
	elog "p +tipa.map"
	elog "to /usr/share/texmf/dvips/config/config.ps"
	elog
}

pkg_postrm() {
	einfo "Running mktexlsr..."
	mktexlsr || die "mktexlsr failed"
}
