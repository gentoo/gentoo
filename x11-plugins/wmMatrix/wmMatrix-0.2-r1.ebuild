# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmMatrix/wmMatrix-0.2-r1.ebuild,v 1.7 2014/08/10 20:03:28 slyfox Exp $

inherit eutils toolchain-funcs multilib

DESCRIPTION="WMaker DockApp: Slightly modified version of Jamie Zawinski's xmatrix screenhack"
SRC_URI="http://dockapps.windowmaker.org/download.php/id/17/${P}.tar.gz"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/10"

CDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${CDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"
RDEPEND="${CDEPEND}
	x11-misc/xscreensaver"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	# this version is distributed with compiled binaries!
	make clean
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)" || die "compile failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "install failed"
}
