# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A tool similar to grep which searches text in PDFs"
HOMEPAGE="http://www.pdfgrep.org/"
SRC_URI="http://www.pdfgrep.org/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="+pcre test unac"
RESTRICT="!test? ( test )"

RDEPEND="
	app-text/poppler:=[cxx]
	dev-libs/libgcrypt:0=
	pcre? ( dev-libs/libpcre[cxx] )
	unac? ( app-text/unac )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
			dev-texlive/texlive-latex
			dev-texlive/texlive-latexrecommended
			dev-util/dejagnu
		)"

src_configure() {
	econf \
		$(use_with pcre libpcre) \
		$(use_with unac)
}
