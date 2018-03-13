# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Multiple PC hardware emulator."
HOMEPAGE="https://pcem-emulator.co.uk/"
SRC_URI="https://pcem-emulator.co.uk/files/PCemV${PV}Linux.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/openal media-libs/libsdl2 x11-libs/wxGTK"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install() {
	dobin pcem
}