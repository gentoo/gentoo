# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Set of matching libre/open fonts funded by Canonical"
HOMEPAGE="https://design.ubuntu.com/font/"
SRC_URI="https://assets.ubuntu.com/v1/fad7939b-${P}.zip -> ${P}.zip"

LICENSE="UbuntuFontLicense-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

BDEPEND="app-arch/unzip"

DOCS=( CONTRIBUTING.txt FONTLOG.txt README.txt )

FONT_SUFFIX="ttf"

src_prepare() {
	default
	rm Ubuntu-M*.ttf || die
}
