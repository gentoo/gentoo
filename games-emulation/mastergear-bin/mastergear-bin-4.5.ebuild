# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SEGA Master System / Game Gear emulator"
HOMEPAGE="https://fms.komkon.org/MG/"
SRC_URI="https://fms.komkon.org/MG/MG${PV//\./}-Ubuntu-x86-bin.tgz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip"

RDEPEND=">=sys-libs/glibc-2.15
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	|| ( media-sound/pulseaudio media-sound/apulse )"

S="${WORKDIR}"

src_install() {
	newbin mg mastergear
	docinto html
	dodoc MG.html
}
