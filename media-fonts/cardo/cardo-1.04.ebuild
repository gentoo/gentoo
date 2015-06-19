# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/cardo/cardo-1.04.ebuild,v 1.2 2011/08/15 00:52:37 dirtyepic Exp $

inherit font

DESCRIPTION="Unicode font for classicists, medievalists and linguists"
HOMEPAGE="http://scholarsfonts.net/cardofnt.html"
SRC_URI="http://scholarsfonts.net/${PN}${PV//./}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="Manual104s.pdf"
