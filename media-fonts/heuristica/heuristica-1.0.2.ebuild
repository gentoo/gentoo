# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="A font based on Adobe Utopia"
HOMEPAGE="https://heuristica.sourceforge.io/"
SRC_URI="mirror://sourceforge/heuristica/${PN}-ttf-${PV}.tar.xz
	mirror://sourceforge/heuristica/${PN}-otf-${PV}.tar.xz
	mirror://sourceforge/heuristica/${PN}-pfb-${PV}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

FONT_SUFFIX="otf pfb ttf"
FONT_S="${S}"
DOCS="FontLog.txt"
