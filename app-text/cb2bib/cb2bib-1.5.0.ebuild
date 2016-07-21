# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Tool for extracting unformatted bibliographic references"
HOMEPAGE="http://www.molspaces.com/cb2bib/"
SRC_URI="http://www.molspaces.com/dl/progs/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 x86"
IUSE="debug +lzo +webkit"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	x11-libs/libX11
	lzo? ( dev-libs/lzo:2 )
	webkit? ( dev-qt/qtwebkit:4 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare

	# Fix desktop files
	sed -i -e '/Keywords=/ s/$/;/' c2bscripts/{c2bciter,cb2bib}.desktop || die
}

src_configure() {
	local mycmakeargs=(
		-DC2B_USE_LZO=$(use lzo && echo ON || echo OFF)
		-DC2B_USE_WEBKIT=$(use webkit && echo ON || echo OFF)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	einfo
	elog "For best functionality, emerge the following packages:"
	elog "    app-text/poppler[utils] - for data import from PDF files"
	elog "    app-text/dvipdfm        - for data import from DVI files"
	elog "    app-text/bibutils       - for data import from ISI, endnote format"
	elog "    media-fonts/jsmath      - for displaying mathematical notation"
	elog "    media-libs/exiftool     - for proper UTF-8 metadata writing in PDF"
	elog "                              text strings"
	elog "    virtual/latex-base      - to check for BibTeX file correctness and to get"
	elog "                              nice printing through the shell script bib2pdf"
	einfo
}
