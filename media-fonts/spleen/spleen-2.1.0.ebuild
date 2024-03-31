# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo font

DESCRIPTION="Monospaced bitmap fonts for consoles and terminals"
HOMEPAGE="https://www.cambus.net/spleen-monospaced-bitmap-fonts/
	https://github.com/fcambus/spleen/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcambus/${PN}.git"
else
	SRC_URI="https://github.com/fcambus/${PN}/releases/download/${PV}/${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"

DOCS=( AUTHORS ChangeLog README.md )
FONT_SUFFIX="otf pcf.gz psfu.gz"

src_compile() {
	edo gzip -n9 *.pcf *.psfu
}
