# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A tool similar to grep which searches text in PDFs"
HOMEPAGE="https://pdfgrep.org/"
SRC_URI="https://www.pdfgrep.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pcre test unac"
RESTRICT="!test? ( test )"

RDEPEND="
	app-text/poppler:=[cxx]
	dev-libs/libgcrypt:0=
	pcre? ( dev-libs/libpcre[cxx] )
	unac? ( app-text/unac )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	virtual/pkgconfig
	test? (
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexrecommended
		dev-util/dejagnu
	)"

DOCS="AUTHORS README.md NEWS.md"

src_configure() {
	econf \
		$(use_with pcre libpcre) \
		$(use_with unac)
}
