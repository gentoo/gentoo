# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Gameboy Advance (GBA) emulator for Linux"
HOMEPAGE="http://www.komkon.org/fms/VGBA/"
SRC_URI="http://fms.komkon.org/VGBA/VGBA${PV/.}-Linux-Ubuntu-bin.tgz"

LICENSE="VGBA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip"
IUSE=""

RDEPEND="
	x11-libs/libXext
	sys-libs/zlib
"

QA_PREBUILT="/opt/bin/vgba"

S="${WORKDIR}"

src_install() {
	into /opt
	dobin vgba
	HTML_DOCS="VGBA.html" einstalldocs
}
