# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

MY_P="KanjiStrokeOrders_v${PV}"
DESCRIPTION="Font to view stroke order diagrams for Kanji, Kana and etc"
HOMEPAGE="https://sites.google.com/site/nihilistorguk/"
SRC_URI="https://sites.google.com/site/nihilistorguk/Home/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# Only installs fonts
RESTRICT="strip binchecks"

DEPEND="app-arch/unzip"
RDEPEND="!=kde-apps/kiten-18.08.2-r0"

S="${WORKDIR}"
FONT_S="${S}"

FONT_SUFFIX="ttf"
DOCS="readme_en_v${PV}.txt"
