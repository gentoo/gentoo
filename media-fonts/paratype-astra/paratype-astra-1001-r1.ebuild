# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="ParaType Astra Sans/Serif fonts metrically compatible with Times New Roman"
HOMEPAGE="https://www.paratype.ru/cinfo/news.asp?NewsId=3469"
SRC_URI="http://astralinux.com/images/fonts/PTAstraSans&Serif_TTF_ver${PV}.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~loong ~riscv x86"
IUSE="X"

BDEPEND="app-arch/unzip"
RDEPEND="
	!media-fonts/paratype-astra-sans
	!media-fonts/paratype-astra-serif
"

FONT_SUFFIX="ttf"
