# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit font versionator

DESCRIPTION="A typeface designed for source code"
HOMEPAGE="https://github.com/source-foundry/Hack"
SRC_URI="https://github.com/source-foundry/Hack/releases/download/v${PV}/Hack-v${PV}-ttf.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""

FONT_SUFFIX="ttf"

src_unpack() {
	mkdir "${S}" && cd "${S}"
	unpack ${A}
}
