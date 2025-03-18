# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature qmake-utils xdg-utils

DESCRIPTION="Tool for extracting unformatted bibliographic references"
HOMEPAGE="https://www.molspaces.com/cb2bib/"
SRC_URI="https://www.molspaces.com/dl/progs/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lzo"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	lzo? ( dev-libs/lzo:2 )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CHANGELOG )

src_prepare() {
	default

	sed -e "s|../AUTHORS ../COPYRIGHT ../LICENSE ../CHANGELOG||" \
		-i src/src.pro || die

	sed -i -e "s/qtHaveModule(webkitwidgets)/false/g" src/src.pro || die
}

src_configure() {
	eqmake5 \
		$(use !lzo && echo -config disable_lzo)
}

src_compile() {
	# bug #709940
	emake -j1
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	optfeature "data import from PDF files" app-text/poppler[utils]
	optfeature "data import from DVI files" app-text/dvipdfm
	optfeature "data import from ISI files, endnote format" app-text/bibutils
	optfeature "display mathematical notation" media-fonts/jsmath
	optfeature "proper UTF-8 metadata writing in PDF text strings" \
			   media-libs/exiftool
	optfeature "check for BibTeX file correctness, nice printing \
			   through the bib2pdf shell script" virtual/latex-base
}

pkg_postrm() {
	xdg_desktop_database_update
}
