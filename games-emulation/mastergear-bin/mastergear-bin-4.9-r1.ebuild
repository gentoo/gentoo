# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="SEGA Master System / Game Gear emulator"
HOMEPAGE="https://fms.komkon.org/MG/"
SRC_URI="https://fms.komkon.org/MG/MG${PV/./}-Ubuntu-x86-bin.tgz"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

RDEPEND="
	|| (
		media-libs/libpulse
		media-sound/apulse[sdk]
	)
	sys-libs/zlib:=
	x11-libs/libX11
	x11-libs/libXext"

QA_PREBUILT="usr/bin/mastergear"

src_install() {
	newbin mg mastergear

	docinto html
	dodoc MG.html
}
