# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit font

DESCRIPTION="A sanserif typeface in the style of xkcd"
HOMEPAGE="http://antiyawn.com/uploads/humorsans.html"
SRC_URI="http://www.antiyawn.com/uploads/${P}.ttf"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

FONT_S="${S}"
FONT_SUFFIX="ttf"

src_unpack() {
	cp "${DISTDIR}/${A}" "${FONT_S}/${PN}.${FONT_SUFFIX}"
}
