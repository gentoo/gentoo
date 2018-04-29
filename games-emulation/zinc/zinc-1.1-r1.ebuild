# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An x86 binary-only emulator for Sony ZN-1, ZN-2, and Namco System 11 arcades"
HOMEPAGE="http://caesar.logiqx.com/php/emulator.php?id=zinc_linux"
SRC_URI="http://caesar.logiqx.com/zips/emus/linux/zinc_linux/${P//[-.]/}-lnx.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"
QA_PREBUILT="/opt/bin/zinc /usr/lib*/*.so"

RDEPEND="
	x11-libs/libXext[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
"

S="${WORKDIR}/zinc"

src_install() {
	exeinto /opt/bin
	doexe zinc
	dolib.so libcontrolznc.so librendererznc.so libsoundznc.so libs11player.so
	einstalldocs
}
