# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Bhutanese/Tibetan fonts for dzongkha script provided by the Bhutanese government"
HOMEPAGE="https://www.dit.gov.bt/downloads"
SRC_URI="https://www.dit.gov.bt/sites/default/files/dzongkhafonts.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"

RESTRICT="mirror bindist"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

src_unpack() {
	default
	unpack ./*.zip
}
