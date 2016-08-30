# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Analogue clock utility for X Windows"
HOMEPAGE="http://www.tigr.net/"
SRC_URI="${HOMEPAGE}afterstep/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="jpeg"

RDEPEND="x11-libs/libXpm
	x11-libs/libSM
	jpeg? ( virtual/jpeg:0 )"

DEPEND="${RDEPEND}
	x11-proto/xproto"

PATCHES=( "${FILESDIR}/respect-ldflags.patch" )

src_configure() {
	econf $(use_enable jpeg)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install () {
	dobin "${PN}"
	newman "${PN}.man" "${PN}.1"
	einstalldocs
}
