# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib toolchain-funcs

DESCRIPTION="dockapp that shows lunar ephemeris to a high accuracy"
SRC_URI="http://dockapps.windowmaker.org/download.php/id/21/${P}.tar.gz"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/14"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc sparc x86"
IUSE=""

S="${WORKDIR}/${P}/Src"

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
