# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Monitor the utilization level of memory, cache and swap space"
HOMEPAGE="http://www.tigr.net/"
SRC_URI="${HOMEPAGE}afterstep/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="jpeg"

RDEPEND="x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXpm
	x11-libs/libXext
	jpeg? ( virtual/jpeg:0 )"
DEPEND="${RDEPEND}
	x11-proto/xproto"

PATCHES=( "${FILESDIR}/respect-ldflags.patch" )

src_configure() {
	econf $(use_enable jpeg)
}

src_compile() {
	emake CC=$(tc-getCC) LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin "${PN}"
	newman "${PN}.man" "${PN}.1"
	einstalldocs
}
