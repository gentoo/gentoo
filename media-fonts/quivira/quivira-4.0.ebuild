# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/quivira/quivira-4.0.ebuild,v 1.1 2014/06/30 12:36:16 chithanh Exp $

EAPI=5

MY_PN="${PN/q/Q}"

inherit font

DESCRIPTION="Unicode font for alphabetic writing systems and elder scripts like Runes, Gothic and ancient Greek"
HOMEPAGE="http://www.quivira-font.com/"
SRC_URI="http://www.quivira-font.com/files/${MY_PN}.otf -> ${P}.otf
	doc? ( http://www.quivira-font.com/files/${MY_PN}.pdf -> ${P}.pdf
		http://www.quivira-font.com/files/${MY_PN}Testpage.pdf -> ${P}-Testpage.pdf
		http://www.quivira-font.com/files/${MY_PN}Combining.pdf -> ${P}-Combining.pdf
		http://www.quivira-font.com/files/${MY_PN}PUA.pdf -> ${P}-PUA.pdf )"
LICENSE="freedist"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="doc"

S="${WORKDIR}"
FONT_SUFFIX="otf"

src_prepare() {
	cp "${DISTDIR}"/${P}.otf "${S}"/${MY_PN}.otf || die
	if use doc; then
		DOCS="${MY_PN}.pdf ${MY_PN}Testpage.pdf ${MY_PN}Combining.pdf ${MY_PN}PUA.pdf"
		cp "${DISTDIR}"/${P}.pdf "${S}"/${MY_PN}.pdf || die
		cp "${DISTDIR}"/${P}-Testpage.pdf "${S}"/${MY_PN}Testpage.pdf || die
		cp "${DISTDIR}"/${P}-Combining.pdf "${S}"/${MY_PN}Combining.pdf || die
		cp "${DISTDIR}"/${P}-PUA.pdf "${S}"/${MY_PN}PUA.pdf || die
	fi
}
