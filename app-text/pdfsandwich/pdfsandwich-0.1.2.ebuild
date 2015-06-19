# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pdfsandwich/pdfsandwich-0.1.2.ebuild,v 1.1 2014/07/29 13:19:03 tomka Exp $

EAPI=4

DESCRIPTION="generator of sandwich OCR pdf files"
HOMEPAGE="http://www.tobias-elze.de/pdfsandwich"
SRC_URI="mirror://sourceforge/pdfsandwich/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND=">=app-text/tesseract-3.00
	media-gfx/exact-image
	app-text/unpaper
	app-text/ghostscript-gpl"
DEPEND="sys-apps/gawk
	>=dev-lang/ocaml-3.10[ocamlopt]"

src_prepare() {
	sed -i "/^OCAMLOPTFLAGS/s/$/ -ccopt \"\$(CFLAGS) \$(LDFLAGS)\"/" Makefile || die
}

src_install() {
	emake DESTDIR="${D}" install
}

pkg_postinst() {
	elog "pdfsandwich relies on the tesseract library for OCR."
	elog "Consequently language support is determined by tesseract's"
	elog "language support which in turn is controlled via the LINGUAS"
	elog "variable in make.conf."
}
