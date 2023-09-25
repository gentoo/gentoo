# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Remake of the Atari 2600 classic Yar's Revenge"
HOMEPAGE="http://freshmeat.net/projects/yarsrevenge/"
SRC_URI="http://www.autismuk.freeserve.co.uk/yar-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[sound,joystick,video]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/yar-${PV}"

PATCHES=(
	"${FILESDIR}"/${PV}-math.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-configure-clang16.patch
)

src_install() {
	default
	make_desktop_entry "${PN}" "Yar's Revenge"
}
