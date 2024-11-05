# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic

DESCRIPTION="generator of sandwich OCR pdf files"
HOMEPAGE="http://www.tobias-elze.de/pdfsandwich"
SRC_URI="https://downloads.sourceforge.net/pdfsandwich/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="png"

RDEPEND="app-text/tesseract
	media-gfx/exact-image
	app-text/unpaper
	app-text/ghostscript-gpl
	app-text/poppler
	virtual/imagemagick-tools[png?]"
DEPEND="sys-apps/gawk
	>=dev-lang/ocaml-3.10[ocamlopt]"

DOCS=( changelog )

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

QA_FLAGS_IGNORED="/usr/bin/${PN}"
QA_TEXTRELS="/usr/bin/${PN}"

src_prepare() {
	sed -i \
		-e "/^OCAMLOPTFLAGS/s/$/ -ccopt \"\$(CFLAGS) \$(LDFLAGS)\"/" \
		Makefile || die
	# Bug #866043
	filter-lto
	default
}

src_install() {
	default
	doman ${PN}.1
}

pkg_postinst() {
	elog "pdfsandwich relies on the tesseract library for OCR."
	elog "Consequently language support is determined by tesseract's"
	elog "language support which in turn is controlled via the LINGUAS"
	elog "variable in make.conf."
}
