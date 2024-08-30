# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_S="${WORKDIR}"
FONT_SUFFIX="otf ttf"
inherit font

DESCRIPTION="Old Standard - font with wide range of Latin, Greek and Cyrillic characters"
HOMEPAGE="http://www.thessalonica.org.ru/en/fonts.html"
SRC_URI="http://www.thessalonica.org.ru/downloads/${P}.otf.zip
	http://www.thessalonica.org.ru/downloads/${P}.ttf.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~riscv x86"

BDEPEND="app-arch/unzip"

DOCS=( OFL.txt OFL-FAQ.txt FONTLOG.txt )
