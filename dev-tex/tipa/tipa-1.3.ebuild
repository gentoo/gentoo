# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="International Phonetic Alphabet package for LaTeX"
HOMEPAGE="https://www.l.u-tokyo.ac.jp/~fkr/"
SRC_URI="https://www.l.u-tokyo.ac.jp/~fkr/tipa/${P}.tar.gz"

KEYWORDS="amd64 x86"

LICENSE="LPPL-1.2"
SLOT="0"
IUSE=""

DEPEND="virtual/latex-base"
RDEPEND="${DEPEND}"

src_prepare() {
	# install files under /usr/share/texmf/
	sed -e 's@PREFIX=/usr/local/teTeX/share/texmf@PREFIX=/usr/share/texmf@' \
		-i Makefile || die "sed #1 failed"

	sed -e 's/\($(TEXDIR)\)/$(DESTDIR)\/\1/' \
		-e 's/\($(FONTDIR)\)/$(DESTDIR)\/\1/g' \
		-e 's/\($(MAPDIR)\)/$(DESTDIR)\/\1/' \
		-i Makefile || die "sed #2 failed"

	# removing `mktexlsr` from Makefile (leads to access violation)
	sed -e 's/-mktexlsr//' -i Makefile || die "sed #3 failed"
	default
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc doc/*.{tex,sty,bib,bbl}
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
