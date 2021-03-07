# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils

MY_P="${PN}-src-${PV}"
DESCRIPTION="A NES-like platform arcade game"
HOMEPAGE="http://remar.se/andreas/retrobattle/"
SRC_URI="http://remar.se/andreas/retrobattle/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# test is incomplete
RESTRICT="test"

DEPEND="media-libs/libsdl[X,sound,video]
	media-libs/sdl-mixer[wav]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

PATCHES=( "${FILESDIR}"/${P}-{build,sound,gcc6}.patch )

src_install() {
	insinto /usr/share/${PN}
	doins -r "${WORKDIR}"/${MY_P}/data

	newbin "${WORKDIR}"/${MY_P}/${PN} ${PN}.bin
	make_wrapper ${PN} "${PN}.bin \"/usr/share/${PN}\""

	make_desktop_entry ${PN}
	dodoc "${WORKDIR}"/${MY_P}/{manual.txt,README}
}
