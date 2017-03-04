# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Tool for extracting unformatted bibliographic references"
HOMEPAGE="http://www.molspaces.com/cb2bib/"
SRC_URI="http://www.molspaces.com/dl/progs/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lzo webengine +webkit"

REQUIRED_USE="?? ( webkit webengine )"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	lzo? ( dev-libs/lzo:2 )
	webkit? ( dev-qt/qtwebkit:5 )
	webengine? ( dev-qt/qtwebengine:5[widgets] )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CHANGELOG COPYRIGHT )

src_prepare() {
	default

	sed -i -e "s|../AUTHORS ../COPYRIGHT ../LICENSE ../CHANGELOG||" src/src.pro || die

	use webengine || sed -i -e "s/qtHaveModule(webenginewidgets)/false/g" src/src.pro || die
	use webkit || sed -i -e "s/qtHaveModule(webkitwidgets)/false/g" src/src.pro || die
}

src_configure() {
	eqmake5 \
		$(use !lzo && echo -config disable_lzo)
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
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
