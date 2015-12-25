# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="${PN/s/S}"

inherit font

DESCRIPTION="Unicode font for Basic Latin, IPA Extensions, Greek, Cyrillic and many Symbol Blocks"
HOMEPAGE="http://users.teilar.gr/~g1951d/"
SRC_URI="http://users.teilar.gr/~g1951d/${MY_PN}.zip -> ${P}.zip"
LICENSE="Unicode_Fonts_for_Ancient_Scripts"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_prepare() {
	if use doc; then
		DOCS="${MY_PN}.docx ${MY_PN}.pdf"
	fi
}
