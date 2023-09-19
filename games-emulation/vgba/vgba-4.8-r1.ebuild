# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Gameboy Advance (GBA) emulator for Linux"
HOMEPAGE="http://www.komkon.org/fms/VGBA/"
SRC_URI="http://fms.komkon.org/VGBA/VGBA${PV/.}-Linux-Ubuntu-bin.tgz"
S="${WORKDIR}"

LICENSE="VGBA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip"

RDEPEND="
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	sys-libs/zlib[abi_x86_32(-)]
"

QA_PREBUILT="/opt/bin/vgba"

src_install() {
	into /opt
	dobin vgba
	HTML_DOCS="VGBA.html" einstalldocs
}
