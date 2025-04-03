# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature qmake-utils xdg

DESCRIPTION="Tool for extracting unformatted bibliographic references"
HOMEPAGE="https://www.molspaces.com/cb2bib/"
SRC_URI="https://www.molspaces.com/dl/progs/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
# build system supports lzo, lzsse, qt_zlib, avx2, but too painful to expose

DEPEND="
	app-arch/lz4:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsingleapplication
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CHANGELOG COPYRIGHT )

PATCHES=(
	"${FILESDIR}/${P}-qmake.patch" # bug 953061
	"${FILESDIR}/${P}-unbundle-qtsingleapplication.patch" # bug 489152
)

src_configure() {
	eqmake5
}

src_compile() {
	# bug #709940, still needed as of 2.0.2
	emake -j1
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "displaying mathematical notation" "media-fonts/jsmath"
	optfeature "proper UTF-8 metadata writing in PDF text strings" "media-libs/exiftool"
	optfeature "BibTeX file correctness checks and nice printing via bib2pdf shell script" "virtual/latex-base"
	optfeature_header "Install additional packages for optional import data formats:"
	optfeature "PDF files" "app-text/poppler[utils]"
	optfeature "DVI files" "app-text/dvipdfm"
	optfeature "ISI files, endnote format" "app-text/bibutils"
}
