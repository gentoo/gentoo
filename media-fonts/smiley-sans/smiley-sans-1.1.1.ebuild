# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MY_P="${PN}-v${PV}"

DESCRIPTION="Deyi Hei Smiley Sans: an open-source italic sans-serif Chinese font"
HOMEPAGE="https://github.com/atelier-anchor/smiley-sans"
SRC_URI="https://github.com/atelier-anchor/smiley-sans/releases/download/v${PV}/${MY_P}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~loong"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"
