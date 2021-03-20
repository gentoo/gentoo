# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Open source modern DIN fonts"
HOMEPAGE="http://gidole.github.io/"
SRC_URI="https://dev.gentoo.org/~jstein/dist/${P}.zip"
S="${WORKDIR}/GidoleFont"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

BDEPEND="app-arch/unzip"

FONT_SUFFIX="otf ttf"
