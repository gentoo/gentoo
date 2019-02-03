# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils multilib toolchain-funcs

DESCRIPTION="dockapp that shows lunar ephemeris to a high accuracy"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"
HOMEPAGE="https://www.dockapps.net/wmmoonclock"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc sparc x86"
IUSE=""

S="${WORKDIR}/${P}.orig/Src"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-implicit.patch
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)" || die "parallel make failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc ../BUGS
}
