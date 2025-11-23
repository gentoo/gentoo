# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Adjusts photo timestamps based on clock photos"
HOMEPAGE="https://git.zx2c4.com/clockphoto/about/"
SRC_URI="https://git.zx2c4.com/clockphoto/snapshot/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
"
RDEPEND="${DEPEND}
	media-gfx/exiv2
"

src_configure() {
	eqmake6
}

src_install() {
	dobin clockphoto
}
