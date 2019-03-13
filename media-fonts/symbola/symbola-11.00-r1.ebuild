# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/s/S}"

inherit font

DESCRIPTION="Unicode font for Latin, IPA Extensions, Greek, Cyrillic and many Symbol Blocks"
HOMEPAGE="http://users.teilar.gr/~g1951d/"
SRC_URI="http://users.teilar.gr/~g1951d/${MY_PN}.zip -> ${P}.zip doc? ( http://users.teilar.gr/~g1951d/${MY_PN}.pdf -> ${P}.pdf )"
LICENSE="Unicode_Fonts_for_Ancient_Scripts"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_prepare() {
	if use doc; then
		DOCS="${DISTDIR}/${P}.pdf"
	fi
	default
}
