# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="Tetris clone with multiplayer support"
HOMEPAGE="https://github.com/quadra-game/quadra"
SRC_URI="https://github.com/quadra-game/quadra/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/boost:=
	media-libs/libpng:=
	media-libs/libsdl2[sound,video]
	virtual/zlib:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-clang.patch
	"${FILESDIR}"/${P}-boost-1.89.patch # bug 963368
)

src_prepare() {
	default
	sed -i -e "/^datagamesdir/s|\/games|\/${PN}|" Makefile.am || die
	eautoreconf
}

src_install() {
	default
	dodoc NEWS.md
	make_desktop_entry ${PN} ${PN^}
}
