# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Font based on Adobe Utopia"
HOMEPAGE="https://sourceforge.net/projects/heuristica/"
SRC_URI="https://downloads.sourceforge.net/heuristica/${PN}-ttf-${PV}.tar.xz
	https://downloads.sourceforge.net/heuristica/${PN}-otf-${PV}.tar.xz
	https://downloads.sourceforge.net/heuristica/${PN}-pfb-${PV}.tar.xz"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~loong ~riscv x86"
IUSE=""

DOCS=( FontLog.txt )

FONT_SUFFIX="otf pfb ttf"
