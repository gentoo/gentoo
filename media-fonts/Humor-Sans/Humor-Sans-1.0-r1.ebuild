# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Sans-serif typeface in the style of xkcd"
HOMEPAGE="http://antiyawn.com/uploads/humorsans.html"
SRC_URI="http://www.antiyawn.com/uploads/${P}.ttf"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

FONT_SUFFIX="ttf"

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}/${PN}.${FONT_SUFFIX}" || die
}
