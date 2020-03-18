# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils gnome2-utils

DESCRIPTION="a 4x4 puzzle on a 64x64 mini window"
HOMEPAGE="https://people.debian.org/~godisch/wmpuzzle/"
SRC_URI="https://people.debian.org/~godisch/wmpuzzle/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gcc-10.patch )
S=${WORKDIR}/${P}/src

src_install() {
	dobin ${PN}

	dodoc ../{CHANGES,README}
	newicon -s 48 numbers.xpm ${PN}.xpm
	doman ${PN}.6
	make_desktop_entry ${PN}
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
