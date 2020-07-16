# Copyright 2009-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit font

MY_P="KanjiStrokeOrders_v${PV}"

DESCRIPTION="Font for viewing stroke order diagrams for kanji, kana and other characters"
HOMEPAGE="https://sites.google.com/site/nihilistorguk/"
SRC_URI="https://sites.google.com/site/nihilistorguk/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE=""
RESTRICT="binchecks"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="readme_en_v${PV}.txt"
