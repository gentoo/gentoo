# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Unicode font for classicists, medievalists and linguists"
HOMEPAGE="http://scholarsfonts.net/cardofnt.html"
SRC_URI="http://scholarsfonts.net/${PN}${PV//./}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="Manual104s.pdf"
