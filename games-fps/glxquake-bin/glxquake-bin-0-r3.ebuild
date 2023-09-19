# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A binary that works with any 3D-graphics-card that supports the glx X-extension"
HOMEPAGE="http://mfcn.ilo.de/glxquake/"
SRC_URI="http://www.wh-hms.uni-ulm.de/~mfcn/shared/glxquake/glxquake.tar.gz"
S="${WORKDIR}"/glxquake

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip"

RDEPEND="
	sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXxf86vm[abi_x86_32(-)]
	x11-libs/libXxf86dga[abi_x86_32(-)]
"

QA_PREBUILT="usr/bin/glquake"

src_install() {
	dobin glquake
	dodoc README
}

pkg_postinst() {
	elog "To play with ${PN}, create a subdirectory called id1"
	elog "Copy the pak0.pak, and eventually pak1.pak into this subdirectory"
	elog "You can get pak0.pa by emerging games-fps/quake1-demodata"
	elog "(or use the disc)"
	elog "The file pak0.pak will be in /usr/share/quake1/demo/"
	elog "You can now run glxquake by executing glquake"
}
