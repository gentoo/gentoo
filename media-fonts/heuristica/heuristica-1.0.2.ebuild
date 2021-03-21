# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Font based on Adobe Utopia"
HOMEPAGE="https://sourceforge.net/projects/heuristica/"
SRC_URI="mirror://sourceforge/heuristica/${PN}-ttf-${PV}.tar.xz
	mirror://sourceforge/heuristica/${PN}-otf-${PV}.tar.xz
	mirror://sourceforge/heuristica/${PN}-pfb-${PV}.tar.xz"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS=( FontLog.txt )

FONT_SUFFIX="otf pfb ttf"
