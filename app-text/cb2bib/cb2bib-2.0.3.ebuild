# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature qmake-utils xdg

DESCRIPTION="Tool for extracting unformatted bibliographic references"
HOMEPAGE="https://www.molspaces.com/cb2bib/"
SRC_URI="https://www.molspaces.com/dl/progs/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
# build system supports lzo, lzsse, qt_zlib, avx2, but too painful to expose
# bundles qtsingleapplication once again since 2.0.3

DEPEND="
	app-arch/lz4:=
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qt5compat:6
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CHANGELOG COPYRIGHT )

PATCHES=( "${FILESDIR}/${PN}-2.0.2-qmake.patch" ) # bug 953061

src_configure() {
	eqmake6
}

src_compile() {
	# bug #709940, still needed as of 2.0.2
	emake -j1
}

src_test() {
	bin/cb2bib --test 2>&1 | tee test.log || die
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
