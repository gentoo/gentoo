# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
		media-sound/pulseaudio
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
