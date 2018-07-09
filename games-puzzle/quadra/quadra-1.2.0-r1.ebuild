# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A tetris clone with multiplayer support"
HOMEPAGE="https://github.com/quadra-game/quadra"
SRC_URI="https://github.com/${PN}-game/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXxf86vm
	x11-libs/libXext
	media-libs/libpng:0=
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	sys-devel/bc
	x11-base/xorg-proto
"

src_prepare() {
	default
	sed -i \
		-e "/^libgamesdir:=/s:/games:/${PN}:" \
		-e "/^datagamesdir:=/s:/games:/${PN}:" \
		config/config.mk.in || die
	eapply "${FILESDIR}"/${P}-format.patch
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins ${PN}.res
	doicon images/${PN}.xpm
	make_desktop_entry ${PN} Quadra

	HTML_DOCS="help/*" einstalldocs
}
