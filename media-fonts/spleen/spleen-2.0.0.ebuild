# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Monospaced bitmap fonts for consoles and terminals"
HOMEPAGE="https://www.cambus.net/spleen-monospaced-bitmap-fonts/
	https://github.com/fcambus/spleen/"
SRC_URI="https://github.com/fcambus/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( AUTHORS ChangeLog README.md )
FONT_SUFFIX="otf pcf.gz psfu.gz"

src_compile() {
	gzip -n9 *.pcf *.psfu || die
}
