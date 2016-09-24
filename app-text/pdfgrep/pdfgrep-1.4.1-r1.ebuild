# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A tool similar to grep which searches text in PDFs"
HOMEPAGE="http://pdfgrep.org/"
SRC_URI="https://pdfgrep.org/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~x86"
IUSE="+pcre test unac"

RDEPEND="
	app-text/poppler:=[cxx]
	pcre? ( dev-libs/libpcre[cxx] )
	unac? ( app-text/unac )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
			dev-texlive/texlive-latex
			dev-util/dejagnu
		)"

src_configure() {
	econf \
		$(use_with pcre libpcre) \
		$(use_with unac)
}
