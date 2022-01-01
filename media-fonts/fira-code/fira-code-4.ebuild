# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Monospaced font with programming ligatures"
HOMEPAGE="https://github.com/tonsky/FiraCode"
SRC_URI="https://github.com/tonsky/FiraCode/archive/${PV}.tar.gz -> ${P}.tar.gz
https://github.com/tonsky/FiraCode/files/412440/FiraCode-Regular-Symbol.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

S="${WORKDIR}/FiraCode-${PV}"
FONT_S="${S}/distr/ttf"
FONT_SUFFIX="ttf otf"

DOCS=( README.md )

BDEPEND="app-arch/unzip"

src_prepare() {
	default
	mv "${WORKDIR}"/*.otf "${FONT_S}" || die
}
