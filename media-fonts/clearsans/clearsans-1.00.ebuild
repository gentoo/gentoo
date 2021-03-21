# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="OpenType font optimized for readability on small screens"
HOMEPAGE="https://01.org/clear-sans"
SRC_URI="https://01.org/sites/default/files/downloads/clear-sans/${P}.zip"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="binchecks strip"

BDEPEND="app-arch/unzip"

FONT_S="${S}/TTF"
FONT_SUFFIX="ttf"
