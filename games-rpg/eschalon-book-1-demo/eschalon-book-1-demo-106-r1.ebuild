# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

DESCRIPTION="Classic role-playing game"
HOMEPAGE="https://basiliskgames.com/eschalon-book-i/"
SRC_URI="https://dev.gentoo.org/~calchan/distfiles/${P}.tar.gz"
S="${WORKDIR}/Eschalon Book I Demo"

LICENSE="eschalon-book-1-demo"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

QA_PREBUILT="opt/*"

RDEPEND="
	>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXxf86vm[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]"

src_install() {
	insinto /opt/${PN}
	doins -r data music sound *pdf *pak help.txt

	exeinto /opt/${PN}
	doexe "Eschalon Book I Demo"

	make_desktop_entry ${PN} "Eschalon: Book I (Demo)"
	make_wrapper ${PN} "\"./Eschalon Book I Demo\"" /opt/${PN}
}
