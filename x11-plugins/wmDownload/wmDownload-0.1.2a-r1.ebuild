# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib toolchain-funcs

DESCRIPTION="dockapp that displays how much data you've received on each eth and ppp device"
SRC_URI="mirror://sourceforge/wmdownload/${P}.tar.gz"
HOMEPAGE="http://wmdownload.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="<x11-libs/libdockapp-0.7
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)" || die "compile failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc CHANGELOG CREDITS HINTS README TODO
}
