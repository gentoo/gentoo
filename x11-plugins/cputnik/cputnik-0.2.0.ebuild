# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/cputnik/cputnik-0.2.0.ebuild,v 1.6 2014/08/10 20:01:20 slyfox Exp $

inherit eutils toolchain-funcs

DESCRIPTION="cputnik is a simple cpu monitor dockapp"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/273"
SRC_URI="http://dockapps.windowmaker.org/download.php/id/576/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S=${WORKDIR}/${P}/src

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die "Compilation failed"
}

src_install() {
	dobin cputnik || die "dobin failed."
	dodoc ../{AUTHORS,NEWS,README}
}
