# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_PN="7kaa"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Seven Kingdoms: Ancient Adversaries"
HOMEPAGE="https://7kfans.com/"
SRC_URI="https://github.com/the3dfxdude/${MY_PN}/releases/download/v${PV}/${MY_P}.tar.xz
	https://dev.gentoo.org/~pinkbyte/distfiles/${MY_PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/enet:1.3=
	media-libs/libsdl2[X,video]
	media-libs/openal
	net-misc/curl"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-fortify.patch" )

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${MY_P}.tar.xz
}

src_install() {
	default

	doicon "${DISTDIR}/${MY_PN}.png"
	make_desktop_entry "${MY_PN}" "Seven Kingdoms: Ancient Adversaries" "${MY_PN}" "Game;StrategyGame"
}
