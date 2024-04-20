# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An x86 binary-only emulator for Sony ZN-1, ZN-2, and Namco System 11 arcades"
HOMEPAGE="http://caesar.logiqx.com/php/emulator.php?id=zinc_linux"
SRC_URI="http://caesar.logiqx.com/zips/emus/linux/zinc_linux/${P//[-.]/}-lnx.tar.bz2"
S="${WORKDIR}/zinc"

LICENSE="freedist"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip"

QA_PREBUILT="/opt/bin/zinc /usr/lib*/*.so"
QA_EXECSTACK="
	usr/lib*/libs11player.so
	opt/bin/zinc
"

RDEPEND="
	sys-libs/glibc
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	amd64? ( sys-libs/libstdc++-v3:5[multilib] )
	x86? ( sys-libs/libstdc++-v3:5 )
"

src_install() {
	default

	exeinto /opt/bin
	doexe zinc
	dolib.so libcontrolznc.so librendererznc.so libsoundznc.so libs11player.so
}
