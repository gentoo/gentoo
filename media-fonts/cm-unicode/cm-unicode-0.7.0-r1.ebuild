# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Computer Modern Unicode fonts"
HOMEPAGE="https://cm-unicode.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-ttf.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS=( Changes FAQ FontLog.txt README )

FONT_SUFFIX="ttf"
