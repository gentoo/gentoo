# Copyright 2009-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Font for viewing stroke order diagrams for kanji, kana and other characters"
HOMEPAGE="https://sites.google.com/site/nihilistorguk/"
SRC_URI="https://sites.google.com/site/nihilistorguk/KanjiStrokeOrders_v${PV}.zip"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE=""
RESTRICT="binchecks"

BDEPEND="app-arch/unzip"

DOCS=( readme_en_v${PV}.txt )

FONT_SUFFIX="ttf"
