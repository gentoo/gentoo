# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop

RENPY_SLOT="6.99"

DESCRIPTION="Bishoujo-style visual novel by Four Leaf Studios"
HOMEPAGE="https://www.katawa-shoujo.com"
SRC_URI="https://dl.katawa-shoujo.com/gold_${PV}/%5B4ls%5D_katawa_shoujo_${PV}-%5Blinux-x86%5D%5B18161880%5D.tar.bz2 -> ${P}.tar.bz2"

LICENSE="CC-BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="games-engines/renpy:${RENPY_SLOT}"

S="${WORKDIR}/Katawa Shoujo-${PV}-linux"

src_install() {
	insinto "/usr/share/${PN}"
	doins -r game/.
	make_wrapper ${PN} "renpy-${RENPY_SLOT} '${EPREFIX}/usr/share/${PN}'"

	make_desktop_entry ${PN} "Katawa Shoujo" applications-games

	if use doc; then
		dodoc "Game Manual.pdf"
	fi
}
