# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/astime/astime-2.8-r1.ebuild,v 1.9 2014/08/10 20:01:02 slyfox Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Analogue clock utility for X Windows"
HOMEPAGE="http://www.tigr.net/"
SRC_URI="http://www.tigr.net/afterstep/download/astime/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="jpeg"

RDEPEND="x11-libs/libXpm
	x11-libs/libSM
	jpeg? ( virtual/jpeg )"

DEPEND="${RDEPEND}
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	econf $(use_enable jpeg) || die "econf failed"
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install () {
	dodir /usr/bin
	dodir /usr/share/man/man1

	emake DESTDIR="${D}" install || die
	dodoc CHANGES README
}
