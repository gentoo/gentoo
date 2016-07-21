# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MY_PN="${PN/s/S}"

inherit font

DESCRIPTION="Unicode font for Basic Latin, IPA Extensions, Greek, Cyrillic and many Symbol Blocks"
HOMEPAGE="http://users.teilar.gr/~g1951d/"
SRC_URI="http://users.teilar.gr/~g1951d/${MY_PN}.ttf -> ${P}.ttf
	doc? ( http://users.teilar.gr/~g1951d/${MY_PN}.docx -> ${P}.docx
		http://users.teilar.gr/~g1951d/${MY_PN}.pdf -> ${P}.pdf )"
LICENSE="Unicode_Fonts_for_Ancient_Scripts"

SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="doc"

S="${WORKDIR}"
FONT_SUFFIX="ttf"

src_prepare() {
	cp "${DISTDIR}"/${P}.ttf "${S}"/${MY_PN}.ttf || die
	if use doc; then
		DOCS="${MY_PN}.docx ${MY_PN}.pdf"
		cp "${DISTDIR}"/${P}.docx "${S}"/${MY_PN}.docx || die
		cp "${DISTDIR}"/${P}.pdf "${S}"/${MY_PN}.pdf || die
	fi
}
