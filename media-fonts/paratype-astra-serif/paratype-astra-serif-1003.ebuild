# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="ParaType Astra Serif fonts metrically compatible with Times New Roman"
HOMEPAGE="https://astralinux.ru/information/#section-fonts-astra"
SRC_URI="https://astralinux.ru/information/fonts-astra/font-ptastra-serif-ver${PV}.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv ~x86"
IUSE="X"

BDEPEND="app-arch/unzip"
RDEPEND="!media-fonts/paratype-astra"

FONT_SUFFIX="ttf"
