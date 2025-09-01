# Copyright 2009-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Font for viewing stroke order diagrams for kanji, kana and other characters"
HOMEPAGE="https://www.nihilist.org.uk/"
SRC_URI="https://drive.google.com/uc?export=download&id=1DKZEYA3PJ8ulLnjYDP5bxzJ3SWi59ghr -> ${P}.zip"
S="${WORKDIR}/KanjiStrokeOrders-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
RESTRICT="binchecks"

BDEPEND="app-arch/unzip"

DOCS=( README_en_v${PV}.txt )

FONT_SUFFIX="ttf"
