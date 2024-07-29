# Copyright 2009-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Font for viewing stroke order diagrams for kanji, kana and other characters"
HOMEPAGE="https://www.nihilist.org.uk/"
SRC_URI="https://drive.google.com/uc?export=download&id=1snpD-IQmT6fGGQjEePHdDzE2aiwuKrz4 -> ${P}.zip"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~riscv x86"
IUSE=""
RESTRICT="binchecks"

BDEPEND="app-arch/unzip"

DOCS=( readme_en_v${PV}.txt )

FONT_SUFFIX="ttf"
