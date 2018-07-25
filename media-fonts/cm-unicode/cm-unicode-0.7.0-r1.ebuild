# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Computer Modern Unicode fonts"
HOMEPAGE="http://cm-unicode.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-ttf.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

FONT_SUFFIX="ttf"
DOCS="Changes FAQ FontLog.txt README"
